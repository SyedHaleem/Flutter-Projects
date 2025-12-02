import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";

// Initialize Firebase Admin
admin.initializeApp();

// Get API keys from Firebase config
const GEMINI_API_KEY = functions.config().ai?.gemini_key;
const USDA_API_KEY = functions.config().usda?.api_key;

// Helper: Call Gemini multimodal (image analysis)
async function callGeminiImageModel(imageUrl: string, params: any) {
  // Replace with actual Gemini API endpoint and payload structure
  const prompt = {
    system: "You are a helpful, conservative food recognition & nutrition aide for diabetic patients. Output only valid JSON.",
    user: `Here is an image of a meal: ${imageUrl}. The user says: ${params.isCooked}, cookingMethod: ${params.cookingMethod}, oilEstimate: ${params.oilEstimate}, portionHint: ${params.portion}.`,
    task: "Identify foodName, ingredients, preparation, estimatedPortionGrams, confidence, possibleFoodNames."
  };
  const response = await axios.post(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent",
    {
      contents: [{ parts: [{ text: JSON.stringify(prompt) }, { inline_data: { mime_type: "image/jpeg", data: imageUrl } }] }]
    },
    { headers: { "Authorization": `Bearer ${GEMINI_API_KEY}` } }
  );
  return response.data;
}

// Helper: Call Gemini text model (meal plan only)
async function callGeminiTextModel(prompt: string) {
  const response = await axios.post(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent",
    { contents: [{ parts: [{ text: prompt }] }] },
    { headers: { "Authorization": `Bearer ${GEMINI_API_KEY}` } }
  );
  return response.data;
}

// Helper: USDA FoodData Central search
async function usdaSearchAndFetch(foodName: string) {
  const searchResp = await axios.get(
    `https://api.nal.usda.gov/fdc/v1/foods/search?query=${encodeURIComponent(foodName)}&api_key=${USDA_API_KEY}`
  );
  if (!searchResp.data.foods || searchResp.data.foods.length === 0) return null;
  const foodId = searchResp.data.foods[0].fdcId;
  const foodResp = await axios.get(
    `https://api.nal.usda.gov/fdc/v1/food/${foodId}?api_key=${USDA_API_KEY}`
  );
  return foodResp.data;
}

// Helper: Extract nutrients
function extractNutrients(usdaFood: any) {
  const out = { calories: 0, carbs: 0, sugar: 0, protein: 0, fat: 0, fiber: 0 } as any;
  if (!usdaFood || !usdaFood.foodNutrients) return out;
  const list = usdaFood.foodNutrients as any[];
  const get = (names: string[]) => {
    for (const n of list) {
      const name = (n.nutrientName || n.nutrient?.name || '').toString().toLowerCase();
      if (names.some(x => name === x.toLowerCase())) {
        const v = n.amount ?? n.value;
        return typeof v === 'number' ? v : parseFloat(v || '0') || 0;
      }
    }
    return 0;
  };
  out.calories = get(["Energy", "Energy (Atwater General Factors)"]);
  out.carbs = get(["Carbohydrate, by difference", "Carbohydrate"]);
  out.sugar = get(["Sugars, total including NLEA", "Sugars, total", "Sugar"]);
  out.protein = get(["Protein"]);
  out.fat = get(["Total lipid (fat)", "Fatty acids, total"]);
  out.fiber = get(["Fiber, total dietary", "Dietary fiber", "Fiber"]);
  return out;
}

// Helper: Glucose risk logic
function computeGlucoseRisk(carbs: number, sugar: number) {
  if (carbs >= 45 || sugar >= 25) return "High";
  if (carbs >= 20 || sugar >= 10) return "Moderate";
  return "Low";
}

// Main function: analyzeFood
export const analyzeFood = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError("unauthenticated", "User must be logged in.");

  const { imageUrl, isCooked, cookingMethod, oilEstimate, portion } = data;

  // 1. Call Gemini multimodal
  const geminiResp = await callGeminiImageModel(imageUrl, { isCooked, cookingMethod, oilEstimate, portion });
  const foodName = geminiResp.foodName || (geminiResp.possibleFoodNames && geminiResp.possibleFoodNames[0]) || "Unknown";

  // 2. Portion grams
  const portionGrams = portion || geminiResp.estimatedPortionGrams || 100;

  // 3. USDA lookup
  const usdaFood = await usdaSearchAndFetch(foodName);
  const nutrientsPer100g = extractNutrients(usdaFood);
  let calories = 0, carbs = 0, sugar = 0, protein = 0, fat = 0, fiber = 0;
  const factor = portionGrams / 100;
  const sumPer100 = (nutrientsPer100g.calories || 0) + (nutrientsPer100g.carbs || 0) + (nutrientsPer100g.sugar || 0) + ((nutrientsPer100g as any).protein || 0) + ((nutrientsPer100g as any).fat || 0) + ((nutrientsPer100g as any).fiber || 0);
  if (sumPer100 > 0) {
    calories = nutrientsPer100g.calories * factor;
    carbs = nutrientsPer100g.carbs * factor;
    sugar = nutrientsPer100g.sugar * factor;
    protein = (nutrientsPer100g as any).protein * factor;
    fat = (nutrientsPer100g as any).fat * factor;
    fiber = (nutrientsPer100g as any).fiber * factor;
  } else {
    // labelNutrients fallback (per serving)
    const label = usdaFood?.labelNutrients;
    const servingSize = parseFloat((usdaFood?.servingSize ?? '0').toString());
    const servingUnit = (usdaFood?.servingSizeUnit || '').toString().toLowerCase();
    const gv = (k: string) => {
      const v = label?.[k]?.value;
      return typeof v === 'number' ? v : parseFloat(v || '0') || 0;
    };
    const lCal = gv('calories');
    const lCarb = gv('carbohydrates');
    const lSugar = gv('sugars');
    const lProt = gv('protein');
    const lFat = gv('fat');
    const lFib = gv('fiber');
    if (label && servingUnit === 'g' && servingSize > 0) {
      const perGramCal = lCal / servingSize;
      const perGramCarb = lCarb / servingSize;
      const perGramSugar = lSugar / servingSize;
      const perGramProt = lProt / servingSize;
      const perGramFat = lFat / servingSize;
      const perGramFib = lFib / servingSize;
      calories = perGramCal * portionGrams;
      carbs = perGramCarb * portionGrams;
      sugar = perGramSugar * portionGrams;
      protein = perGramProt * portionGrams;
      fat = perGramFat * portionGrams;
      fiber = perGramFib * portionGrams;
    } else if (label) {
      calories = lCal; carbs = lCarb; sugar = lSugar; protein = lProt; fat = lFat; fiber = lFib;
    }
  }

  // 4. Glucose risk
  const glucoseRisk = computeGlucoseRisk(carbs, sugar);

  // 5. Get user profile
  const userProfileSnap = await admin.firestore().doc(`users/${uid}/profile`).get();
  const userProfile = userProfileSnap.exists ? userProfileSnap.data() : {};

  // Defensive: ensure userProfile is always an object
  const safeProfile = userProfile || {};

  // 6. Build prompt for Gemini text model (meal plan only)
  const planPrompt = `
SYSTEM: You are a cautious nutrition assistant for diabetic adults. Always include a short health disclaimer and keep recommendations conservative. Return JSON only.

USER: Use the following user profile and current meal analysis to create a personalized meal plan for one day.

Profile:
- age: ${safeProfile.age || ""}
- gender: ${safeProfile.gender || ""}
- weightKg: ${safeProfile.weightKg || ""}
- avgSugarLast3DaysMgDl: ${safeProfile.sugarLast3 ? safeProfile.sugarLast3.join(",") : ""}

CurrentFood:
- foodName: ${foodName}
- calories: ${calories}
- carbs: ${carbs}
- sugar: ${sugar}
- glucoseRisk: ${glucoseRisk}

TASK:
1) Create a 1-day meal plan (breakfast, mid-morning snack, lunch, afternoon snack, dinner) aimed to limit post-prandial glucose spikes given the profile. For each meal include: name, ingredients, approximate portion (grams), estimated calories, carbs, sugar.
2) Return JSON: { "mealPlan": [...], "notes": "..." }
`;

  const planResp = await callGeminiTextModel(planPrompt);

  // 7. Save to Firestore
  const result = {
    foodAnalysis: {
      foodName,
      ingredients: geminiResp.ingredients || [],
      preparation: geminiResp.preparation || "",
      portionGrams,
      calories,
      carbs,
      sugar,
  protein,
  fat,
  fiber,
      glucoseRisk,
    },
  mealPlan: planResp.mealPlan || {},
    warnings: ["Not medical advice. Consult your clinician for treatment/insulin dosing.", ...(geminiResp.confidence && geminiResp.confidence < 0.6 ? ["Low confidence in food recognition. Please confirm."] : [])]
  };

  await admin.firestore().doc(`users/${uid}/history/${Date.now()}`).set(result);

  return result;
});