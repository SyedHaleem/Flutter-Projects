import 'dart:convert';

class FoodAnalysis {
	final String foodName;
	final List<String> ingredients;
	final String preparation;
	final int estimatedPortionGrams;
	final double confidence;
	final List<String> possibleFoodNames;
	final NutritionFacts? nutrition; // filled after USDA lookup
	final String glucoseRisk; // Low / Moderate / High

	FoodAnalysis({
		required this.foodName,
		required this.ingredients,
		required this.preparation,
		required this.estimatedPortionGrams,
		required this.confidence,
		required this.possibleFoodNames,
		required this.glucoseRisk,
		this.nutrition,
	});

	FoodAnalysis copyWith({
		NutritionFacts? nutrition,
		String? glucoseRisk,
		int? estimatedPortionGrams,
		String? foodName,
	}) => FoodAnalysis(
				foodName: foodName ?? this.foodName,
				ingredients: ingredients,
				preparation: preparation,
				estimatedPortionGrams: estimatedPortionGrams ?? this.estimatedPortionGrams,
				confidence: confidence,
				possibleFoodNames: possibleFoodNames,
				glucoseRisk: glucoseRisk ?? this.glucoseRisk,
				nutrition: nutrition ?? this.nutrition,
			);

	Map<String, dynamic> toMap() => {
				'foodName': foodName,
				'ingredients': ingredients,
				'preparation': preparation,
				'estimatedPortionGrams': estimatedPortionGrams,
				'confidence': confidence,
				'possibleFoodNames': possibleFoodNames,
				'glucoseRisk': glucoseRisk,
				'nutrition': nutrition?.toMap(),
			};

	String toJson() => jsonEncode(toMap());

	static FoodAnalysis fromGeminiJson(Map<String, dynamic> json) {
		return FoodAnalysis(
			foodName: json['foodName'] ?? '',
			ingredients: (json['ingredients'] as List?)?.map((e) => e.toString()).toList() ?? [],
			preparation: json['preparation'] ?? '',
			estimatedPortionGrams: (json['estimatedPortionGrams'] ?? 0).toInt(),
			confidence: (json['confidence'] ?? 0).toDouble(),
			possibleFoodNames: (json['possibleFoodNames'] as List?)?.map((e) => e.toString()).toList() ?? [],
			glucoseRisk: 'Unknown',
		);
	}
}

class NutritionFacts {
	final double calories;
	final double carbs;
	final double sugar;
	final double fiber;
	final double protein;
	final double fat;
	final int portionGrams;
	final int per100gCalories;

	NutritionFacts({
		required this.calories,
		required this.carbs,
		required this.sugar,
		required this.fiber,
		required this.protein,
		required this.fat,
		required this.portionGrams,
		required this.per100gCalories,
	});

	Map<String, dynamic> toMap() => {
				'calories': calories,
				'carbs': carbs,
				'sugar': sugar,
				'fiber': fiber,
				'protein': protein,
				'fat': fat,
				'portionGrams': portionGrams,
				'per100gCalories': per100gCalories,
			};
}
