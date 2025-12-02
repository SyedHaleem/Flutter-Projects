import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/food_analysis.dart';
import '../models/meal_plan.dart';
import '../models/user_profile.dart';

class AIService {
	final FirebaseFirestore _firestore = FirebaseFirestore.instance;
	final FirebaseAuth _auth = FirebaseAuth.instance;

	// Ephemeral in-memory meal plan cache for this session
	static final Map<String, MealAndLifestylePlan> _mealPlanCache = {};

	// Debug log buffer and last raw responses for UI
	final List<String> _debugLogs = <String>[];
	final Map<String, dynamic> _lastResponses = <String, dynamic>{};

	void _log(String msg) {
		if (kDebugMode) {
			final ts = DateTime.now().toIso8601String();
			debugPrint('[AIService][$ts] $msg');
		}
		// always store in buffer (cap ~500 entries)
		final ts = DateTime.now().toIso8601String();
		_debugLogs.add('[AIService][$ts] $msg');
		if (_debugLogs.length > 500) _debugLogs.removeRange(0, _debugLogs.length - 500);
	}

	void _clearDebug() {
		_debugLogs.clear();
		_lastResponses.clear();
	}

	Map<String, dynamic> getDebugSnapshot() => {
		'logs': List<String>.from(_debugLogs),
		'responses': Map<String, dynamic>.from(_lastResponses),
	};

	// 1. Save profile
	Future<void> saveUserProfile(UserProfile profile) async {
		final uid = _auth.currentUser?.uid;
		if (uid == null) return;
		final sw = Stopwatch()..start();
		_log('profile SAVE START uid=$uid');
		await _firestore.collection('users').doc(uid).collection('profile').doc('main').set(profile.toMap(), SetOptions(merge: true));
		_log('profile SAVE DONE elapsedMs=${sw.elapsedMilliseconds}');
	}

	// 2. Gemini image + text (multimodal) analysis
	Future<FoodAnalysis> analyzeFoodImage({required Uint8List imageBytes, required bool isCooked, required String cookingMethod, required String oilEstimate, required String portionHint}) async {
		final apiKey = ApiKeys.gemini;
		if (apiKey.isEmpty) throw Exception('Missing GEMINI_API_KEY');
		final sw = Stopwatch()..start();
		_log('analyzeFoodImage START isCooked=$isCooked cookingMethod=$cookingMethod oil=$oilEstimate portionHint=$portionHint imageBytes=${imageBytes.lengthInBytes}');
		final base64Img = base64Encode(imageBytes);
		final combinedPrompt = '''You are a helpful food recognition & nutrition aide for diabetic patients.
Analyze the provided food image and the structured user inputs.
Return ONLY valid JSON with keys: foodName, ingredients (array of strings), preparation, estimatedPortionGrams (int), confidence (0-1), possibleFoodNames (array of strings).

User inputs:
- isCooked: $isCooked
- cookingMethod: $cookingMethod
- oilEstimate: $oilEstimate
- portionHint: $portionHint

JSON schema example:
{"foodName":"Grilled Chicken","ingredients":["chicken","spices"],"preparation":"Grilled with spices","estimatedPortionGrams":180,"confidence":0.82,"possibleFoodNames":["Grilled Chicken Breast","Roasted Chicken"]}
''';

		final body = {
			'contents': [
				{
					'role': 'user',
					'parts': [
						{'inline_data': {'mime_type': 'image/jpeg', 'data': base64Img}},
						{'text': combinedPrompt}
					]
				}
			]
		};

		// Call Gemini with robust fallbacks to avoid 404s on certain model/version paths
		final decoded = await _geminiGenerateWithFallback(apiKey: apiKey, body: body, contextLabel: 'vision');
		_log('Gemini vision OK elapsedMs=${sw.elapsedMilliseconds}');
		final text = decoded['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '{}';
		_log('Gemini vision rawTextLength=${text.length}');
		_lastResponses['geminiVisionRawText'] = text;
		_lastResponses['geminiVisionResp'] = decoded;
		late Map<String, dynamic> jsonResult;
		try {
			jsonResult = jsonDecode(_extractJson(text));
		} catch (_) {
			_lastResponses['geminiVisionParsedError'] = {'raw': text};
			throw Exception('Invalid JSON from Gemini');
		}
		final analysis = FoodAnalysis.fromGeminiJson(jsonResult);
		_lastResponses['geminiVisionParsed'] = jsonResult;
		_log('analyzeFoodImage DONE foodName=${analysis.foodName} portion=${analysis.estimatedPortionGrams}g confidence=${analysis.confidence} possibleAlt=${analysis.possibleFoodNames.length}');
		return analysis;
	}

	String _extractJson(String raw) {
		final start = raw.indexOf('{');
		final end = raw.lastIndexOf('}');
		if (start == -1 || end == -1 || end <= start) return '{}';
		return raw.substring(start, end + 1);
	}

	// 3. USDA lookup
	Future<NutritionFacts?> enrichWithUSDA(FoodAnalysis analysis) async {
		final apiKey = ApiKeys.usda;
		if (apiKey.isEmpty) throw Exception('Missing USDA_API_KEY');
		final sw = Stopwatch()..start();
		_log('USDA search START query="${analysis.foodName}"');
		final searchUri = Uri.https('api.nal.usda.gov', '/fdc/v1/foods/search', {
			'api_key': apiKey,
			'query': analysis.foodName,
			'pageSize': '1'
		});
		final searchResp = await http.get(searchUri);
		_log('USDA search RESP status=${searchResp.statusCode} elapsedMs=${sw.elapsedMilliseconds}');
		if (searchResp.statusCode != 200) return null;
		final searchJson = jsonDecode(searchResp.body);
		_lastResponses['usdaSearch'] = searchJson;
		final foods = searchJson['foods'] as List?;
		if (foods == null || foods.isEmpty) return null;
		final fdcId = foods.first['fdcId'].toString();
		_log('USDA detail START fdcId=$fdcId');

		final detailUri = Uri.https('api.nal.usda.gov', '/fdc/v1/food/$fdcId', {'api_key': apiKey});
		final detailResp = await http.get(detailUri);
		_log('USDA detail RESP status=${detailResp.statusCode} elapsedMs=${sw.elapsedMilliseconds}');
		if (detailResp.statusCode != 200) return null;
		final detailJson = jsonDecode(detailResp.body);
		_lastResponses['usdaDetail'] = detailJson;
		final nutrients = detailJson['foodNutrients'] as List? ?? [];

		double _asDouble(dynamic v) {
			if (v is num) return v.toDouble();
			if (v is String) return double.tryParse(v) ?? 0.0;
			return 0.0;
		}

		double getNExact(String name) {
			final match = nutrients.firstWhere(
				(n) => (n['nutrient']?['name'] ?? '').toString().toLowerCase() == name.toLowerCase(),
				orElse: () => null,
			);
			if (match == null) return 0;
			return _asDouble(match['amount'] ?? match['value']);
		}

		double getNById(int id) {
			final match = nutrients.firstWhere(
				(n) => (n['nutrient']?['id'] ?? -1) == id,
				orElse: () => null,
			);
			if (match == null) return 0;
			return _asDouble(match['amount'] ?? match['value']);
		}

		double getNAny(List<String> names) {
			for (final n in names) {
				final v = getNExact(n);
				if (v != 0) return v;
			}
			return 0;
		}

		// Try primary: per-100g from foodNutrients
		double per100Calories = getNAny(['Energy', 'Energy (Atwater General Factors)']);
		double per100Carbs = getNAny(['Carbohydrate, by difference', 'Carbohydrate']);
		double per100Sugar = getNAny(['Sugars, total including NLEA', 'Sugars, total', 'Sugar', 'Total sugars', 'Total Sugars']);
		if (per100Sugar == 0) {
			// Fallback by nutrient ID for total sugars
			per100Sugar = getNById(2000);
		}
		double per100Protein = getNAny(['Protein']);
		double per100Fat = getNAny(['Total lipid (fat)', 'Fatty acids, total']);
		double per100Fiber = getNAny(['Fiber, total dietary', 'Dietary fiber', 'Fiber']);

		final portionGrams = analysis.estimatedPortionGrams.toDouble();
		double portionCalories;
		double portionCarbs;
		double portionSugar;
		double portionProtein;
		double portionFat;
		double portionFiber;
		int per100gCaloriesInt;

		bool hasAnyPer100 = (per100Calories + per100Carbs + per100Sugar + per100Protein + per100Fat + per100Fiber) > 0;
		if (hasAnyPer100) {
			final factor = portionGrams / 100.0;
			portionCalories = per100Calories * factor;
			portionCarbs = per100Carbs * factor;
			portionSugar = per100Sugar * factor;
			portionProtein = per100Protein * factor;
			portionFat = per100Fat * factor;
			portionFiber = per100Fiber * factor;
			per100gCaloriesInt = per100Calories.toInt();
			// If sugar remained zero but label has sugars, use label-based sugar scaling only
			if (portionSugar == 0) {
				final label = detailJson['labelNutrients'] as Map<String, dynamic>?;
				final servingSize = _asDouble(detailJson['servingSize']);
				final servingUnit = (detailJson['servingSizeUnit'] ?? '').toString().toLowerCase();
				if (label != null) {
					final lSugar = _asDouble(label['sugars']?['value']);
					if (servingUnit == 'g' && servingSize > 0 && lSugar > 0) {
						final perGramSugar = lSugar / servingSize;
						portionSugar = perGramSugar * portionGrams;
					} else if (lSugar > 0) {
						portionSugar = lSugar; // per serving
					}
				}
			}
		} else {
			// Fallback: labelNutrients (often per serving)
			final label = detailJson['labelNutrients'] as Map<String, dynamic>?;
			final servingSize = _asDouble(detailJson['servingSize']);
			final servingUnit = (detailJson['servingSizeUnit'] ?? '').toString().toLowerCase();
			double labelOf(String key) => _asDouble(label?[key]?['value']);
			final lCal = labelOf('calories');
			final lCarb = labelOf('carbohydrates');
			final lSugar = labelOf('sugars');
			final lProt = labelOf('protein');
			final lFat = labelOf('fat');
			final lFib = labelOf('fiber');

			if (label != null && servingUnit == 'g' && servingSize > 0) {
				final perGramCal = lCal / servingSize;
				final perGramCarb = lCarb / servingSize;
				final perGramSugar = lSugar / servingSize;
				final perGramProt = lProt / servingSize;
				final perGramFat = lFat / servingSize;
				final perGramFib = lFib / servingSize;

				portionCalories = perGramCal * portionGrams;
				portionCarbs = perGramCarb * portionGrams;
				portionSugar = perGramSugar * portionGrams;
				portionProtein = perGramProt * portionGrams;
				portionFat = perGramFat * portionGrams;
				portionFiber = perGramFib * portionGrams;
				per100gCaloriesInt = (perGramCal * 100).round();
			} else if (label != null) {
				// Unit not grams or missing; use per-serving values as portion
				portionCalories = lCal;
				portionCarbs = lCarb;
				portionSugar = lSugar;
				portionProtein = lProt;
				portionFat = lFat;
				portionFiber = lFib;
				per100gCaloriesInt = 0; // unknown
			} else {
				// No data available
				portionCalories = 0;
				portionCarbs = 0;
				portionSugar = 0;
				portionProtein = 0;
				portionFat = 0;
				portionFiber = 0;
				per100gCaloriesInt = 0;
			}
		}

		final facts = NutritionFacts(
			calories: portionCalories,
			carbs: portionCarbs,
			sugar: portionSugar,
			fiber: portionFiber,
			protein: portionProtein,
			fat: portionFat,
			portionGrams: analysis.estimatedPortionGrams,
			per100gCalories: per100gCaloriesInt,
		);
		_log('USDA enrich DONE calories=${facts.calories.toStringAsFixed(1)} carbs=${facts.carbs.toStringAsFixed(1)} sugar=${facts.sugar.toStringAsFixed(1)} fiber=${facts.fiber.toStringAsFixed(1)} protein=${facts.protein.toStringAsFixed(1)} fat=${facts.fat.toStringAsFixed(1)}');
		return facts;
	}

	// 4. Risk classification
	String classifyRisk(double carbs, double sugar) {
		if (carbs >= 45 || sugar >= 25) return 'High';
		if (carbs >= 20 || sugar >= 10) return 'Moderate';
		return 'Low';
	}

	// 5. Meal plan generation with Gemini text model (no lifestyle section)
		Future<MealAndLifestylePlan> generateMealPlan({required UserProfile profile, required FoodAnalysis analysis, bool forceNew = false, String? preferences}) async {
		final apiKey = ApiKeys.gemini;
		if (apiKey.isEmpty) throw Exception('Missing GEMINI_API_KEY');
		final sw = Stopwatch()..start();
		_log('mealPlan START food=${analysis.foodName} calories=${analysis.nutrition?.calories.toStringAsFixed(1)} risk=${analysis.glucoseRisk}');

			// Cache key based on food and key nutrition/risk signals
			final key = '${analysis.foodName}|${analysis.nutrition?.calories.round() ?? 0}|${analysis.glucoseRisk}|avg${profile.avgSugar.round()}|reads${profile.lastSugarReadings.map((e)=>e.round()).join(',')}';
			if (!forceNew && _mealPlanCache.containsKey(key)) {
				_log('mealPlan CACHE HIT key=$key');
				return _mealPlanCache[key]!;
			} else if (forceNew) {
				_log('mealPlan CACHE BYPASS key=$key');
			}
	final prompt = '''You are a cautious diabetes nutrition assistant. Return ONLY valid JSON. All recommendations must be suitable for diabetic patients and support stable blood glucose.
User profile:
- age: ${profile.age}
- gender: ${profile.gender}
- weight: ${profile.weight}
- last3SugarReadings: ${profile.lastSugarReadings.map((v)=>v.toStringAsFixed(1)).toList()}
- avgSugarLast3Days: ${profile.avgSugar.toStringAsFixed(1)}

CurrentFood:
- foodName: ${analysis.foodName}
- calories: ${analysis.nutrition?.calories.toStringAsFixed(1) ?? 0}
- carbs: ${analysis.nutrition?.carbs.toStringAsFixed(1) ?? 0}
- sugar: ${analysis.nutrition?.sugar.toStringAsFixed(1) ?? 0}
- glucoseRisk: ${analysis.glucoseRisk}

User preferences (optional): ${preferences ?? 'none provided'}

TASK:
1) Provide 1-day meal plan (breakfast, snack, lunch, snack, dinner) array: mealType, name, portionGrams, calories, carbs, sugar.
2) Provide notes string.
3) If this is a re-generation request, vary the choices from typical options while keeping macros appropriate for the profile and recent glucose readings.
JSON example:
{"mealPlan":[{"mealType":"breakfast","name":"Oatmeal","portionGrams":150,"calories":220,"carbs":32,"sugar":5}],"notes":"Focus on balanced carb distribution."}
''';
		final body = {
			'contents': [
				{
					'role': 'user',
					'parts': [ {'text': prompt} ]
				}
			]
		};

		// Use the same robust fallback logic
		final decoded = await _geminiGenerateWithFallback(apiKey: apiKey, body: body, contextLabel: 'mealPlan');
		_log('Gemini mealPlan OK elapsedMs=${sw.elapsedMilliseconds}');
		final text = decoded['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '{}';
		_lastResponses['geminiMealPlanRawText'] = text;
		_lastResponses['geminiMealPlanResp'] = decoded;
		final jsonResult = jsonDecode(_extractJson(text));
		final plan = MealAndLifestylePlan.fromGeminiJson(jsonResult);
		_lastResponses['geminiMealPlanParsed'] = jsonResult;
		_log('mealPlan DONE meals=${plan.mealPlan.length}');
		_mealPlanCache[key] = plan;
		return plan;
	}

	// Shared: robust Gemini call that retries alternate API versions/models to avoid 404s
	Future<Map<String, dynamic>> _geminiGenerateWithFallback({required String apiKey, required Map<String, dynamic> body, required String contextLabel}) async {
		final headers = {'Content-Type': 'application/json'};
		final models = <String>[
			// Use models that your project lists under GET /v1/models (no 'models/' prefix here)
			// Prefer stable IDs and avoid '-latest' aliases that might map to versions you don't have.
			'gemini-2.5-flash',
			'gemini-2.5-pro',
			'gemini-2.5-flash-lite',
			'gemini-2.0-flash',
			'gemini-2.0-flash-001',
			'gemini-2.0-flash-lite',
			'gemini-2.0-flash-lite-001',
		];
		final apiVersions = <String>['v1', 'v1beta'];
		Object? lastErrBody;
		int? lastStatus;
		for (final ver in apiVersions) {
			for (final m in models) {
				final uri = Uri.parse('https://generativelanguage.googleapis.com/$ver/models/$m:generateContent?key=$apiKey');
				final encodedBody = jsonEncode(body);
				_log('Gemini $contextLabel POST ${uri.path} (${ver}/$m) bodySize=${encodedBody.length}');
				final resp = await http.post(uri, headers: headers, body: encodedBody);
				_log('Gemini $contextLabel RESP status=${resp.statusCode} (${ver}/$m)');
				if (resp.statusCode == 200) {
					try {
						return jsonDecode(resp.body) as Map<String, dynamic>;
					} catch (e) {
						throw Exception('Gemini $contextLabel parse error: $e');
					}
				}
				lastStatus = resp.statusCode;
				lastErrBody = resp.body;
			}
		}
		String msg = 'Gemini $contextLabel error ${lastStatus ?? 'unknown'}';
		try {
			if (lastErrBody is String) {
				final err = jsonDecode(lastErrBody);
				final details = err['error'] ?? err;
				final code = details['code'];
				final m = details['message'];
				if (code != null) msg += ' code=' + code.toString();
				if (m != null) msg += ' msg=' + m.toString();
			}
		} catch (_) {}
		// Add hint for 404 model not found/access issues
		if (lastStatus == 404) {
			msg += ' • Tip: Confirm which models your project lists under GET /v1/models and use those IDs (e.g., gemini-2.5-flash). Do not include the "models/" prefix in the path segment and avoid -latest/-002 aliases unless enabled.';
		}
		throw Exception(msg);
	}

	// 6. Store history
	Future<void> storeHistory({required FoodAnalysis analysis, required MealAndLifestylePlan plan}) async {
		final uid = _auth.currentUser?.uid; if (uid == null) return;
		final ts = DateTime.now().millisecondsSinceEpoch.toString();
		final sw = Stopwatch()..start();
		_log('history SAVE START uid=$uid doc=$ts');
		await _firestore.collection('users').doc(uid).collection('history').doc(ts).set({
			'foodAnalysis': analysis.toMap(),
			'mealPlan': plan.toMap(),
			'createdAt': FieldValue.serverTimestamp(),
		});
		_log('history SAVE DONE doc=$ts elapsedMs=${sw.elapsedMilliseconds}');
	}

	// Orchestrated flow
	Future<(FoodAnalysis, MealAndLifestylePlan?)> fullFlow({required Uint8List imageBytes, required bool isCooked, required String cookingMethod, required String oilEstimate, required String portionHint, required UserProfile profile}) async {
		final sw = Stopwatch()..start();
		_log('fullFlow START');
		_clearDebug();
		// Analyze image
		var analysis = await analyzeFoodImage(imageBytes: imageBytes, isCooked: isCooked, cookingMethod: cookingMethod, oilEstimate: oilEstimate, portionHint: portionHint);
		// USDA enrich
		final nutrition = await enrichWithUSDA(analysis);
		if (nutrition != null) {
			final risk = classifyRisk(nutrition.carbs, nutrition.sugar);
			analysis = analysis.copyWith(nutrition: nutrition, glucoseRisk: risk);
		}
		// Generate meal plan only if nutrition available
		MealAndLifestylePlan? plan;
		if (analysis.nutrition != null) {
			plan = await generateMealPlan(profile: profile, analysis: analysis);
			await storeHistory(analysis: analysis, plan: plan);
		}
		_log('fullFlow DONE risk=${analysis.glucoseRisk} nutritionSet=${analysis.nutrition != null} totalMs=${sw.elapsedMilliseconds}');
		return (analysis, plan);
	}
}
