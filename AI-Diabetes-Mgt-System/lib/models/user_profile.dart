class UserProfile {
	final int age;
	final String gender;
	final double weight;
	final List<double> lastSugarReadings; // last 3
	final double avgSugar;

	UserProfile({
		required this.age,
		required this.gender,
		required this.weight,
		required this.lastSugarReadings,
	}) : avgSugar = lastSugarReadings.isNotEmpty
						? lastSugarReadings.reduce((a, b) => a + b) / lastSugarReadings.length
						: 0;

	Map<String, dynamic> toMap() => {
				'age': age,
				'gender': gender,
				'weight': weight,
				'lastSugarReadings': lastSugarReadings,
				'avgSugarLast3Days': avgSugar,
				'updatedAt': DateTime.now().toIso8601String(),
			};
}
