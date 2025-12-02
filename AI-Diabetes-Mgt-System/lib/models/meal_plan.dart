import 'dart:convert';

class MealItem {
	final String mealType; // breakfast, snack, lunch, etc.
	final String name;
	final int portionGrams;
	final double calories;
	final double carbs;
	final double sugar;

	MealItem({
		required this.mealType,
		required this.name,
		required this.portionGrams,
		required this.calories,
		required this.carbs,
		required this.sugar,
	});

	Map<String, dynamic> toMap() => {
				'mealType': mealType,
				'name': name,
				'portionGrams': portionGrams,
				'calories': calories,
				'carbs': carbs,
				'sugar': sugar,
			};
}

class MealAndLifestylePlan {
	final List<MealItem> mealPlan;
	final String notes;

	MealAndLifestylePlan({required this.mealPlan, required this.notes});

	Map<String, dynamic> toMap() => {
				'mealPlan': mealPlan.map((m) => m.toMap()).toList(),
				'notes': notes,
			};

	String toJson() => jsonEncode(toMap());

	static MealAndLifestylePlan fromGeminiJson(Map<String, dynamic> json) {
		final mealItems = (json['mealPlan'] as List?)?.map((e) {
					return MealItem(
						mealType: e['mealType'] ?? '',
						name: e['name'] ?? '',
						portionGrams: (e['portionGrams'] ?? 0).toInt(),
						calories: (e['calories'] ?? 0).toDouble(),
						carbs: (e['carbs'] ?? 0).toDouble(),
						sugar: (e['sugar'] ?? 0).toDouble(),
					);
				}).toList() ??
				[];
		return MealAndLifestylePlan(
			mealPlan: mealItems,
			notes: json['notes'] ?? '',
		);
	}
}
