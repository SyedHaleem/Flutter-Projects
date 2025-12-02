import 'package:flutter/material.dart';

class ParsedMeal {
  final String mealType;
  final String name;
  final double? grams;
  final double? calories;
  final double? carbs;
  final double? sugar;

  ParsedMeal({
    required this.mealType,
    required this.name,
    this.grams,
    this.calories,
    this.carbs,
    this.sugar,
  });
}

class ParsedPlan {
  final List<ParsedMeal> meals;
  final String? notes;

  ParsedPlan({
    required this.meals,
    this.notes,
  });
}

ParsedPlan parseMealPlan(String text) {
  final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
  final meals = <ParsedMeal>[];
  String? notes;
  for (final l in lines) {
    if (l.startsWith('- ')) {
      // Example: - Breakfast: Oats • 150g • Cal 350 • C 45.0 • S 12.0
      final noDash = l.substring(2).trim();
      final parts = noDash.split(':');
      if (parts.length >= 2) {
        final mealType = parts[0].trim();
        final rest = parts.sublist(1).join(':').trim();
        final fields = rest.split('•').map((s) => s.trim()).toList();
        String name = fields.isNotEmpty ? fields[0] : rest;
        double? grams;
        double? cal;
        double? carbs;
        double? sugar;
        for (final f in fields.skip(1)) {
          final lower = f.toLowerCase();
          if (lower.contains('g')) {
            final numMatch = RegExp(r"([0-9]+(?:\.[0-9]+)?)").firstMatch(f);
            if (numMatch != null) grams = double.tryParse(numMatch.group(1)!);
          }
          if (lower.contains('cal')) {
            final numMatch = RegExp(r"([0-9]+(?:\.[0-9]+)?)").firstMatch(f);
            if (numMatch != null) cal = double.tryParse(numMatch.group(1)!);
          }
          if (lower.startsWith('c ')) {
            final numMatch = RegExp(r"([0-9]+(?:\.[0-9]+)?)").firstMatch(f);
            if (numMatch != null) carbs = double.tryParse(numMatch.group(1)!);
          }
          if (lower.startsWith('s ')) {
            final numMatch = RegExp(r"([0-9]+(?:\.[0-9]+)?)").firstMatch(f);
            if (numMatch != null) sugar = double.tryParse(numMatch.group(1)!);
          }
        }
        meals.add(ParsedMeal(mealType: mealType, name: name, grams: grams, calories: cal, carbs: carbs, sugar: sugar));
      }
    } else if (l.toLowerCase().startsWith('notes:')) {
      notes = l.split(':').sublist(1).join(':').trim();
    }
  }
  return ParsedPlan(meals: meals, notes: notes);
}

String _mealEmoji(String type) {
  final t = type.toLowerCase();
  if (t.contains('breakfast')) return '🥣';
  if (t.contains('lunch')) return '🍱';
  if (t.contains('dinner')) return '🍽️';
  if (t.contains('snack')) return '🍎';
  if (t.contains('dessert')) return '🍮';
  return '🍽️';
}

class MealPlanView extends StatelessWidget {
  final String planText;
  final bool compact;
  final int? maxMeals;

  const MealPlanView({super.key, required this.planText, this.compact = false, this.maxMeals});

  @override
  Widget build(BuildContext context) {
    final parsed = parseMealPlan(planText);
  if (parsed.meals.isEmpty) {
      // Fallback to plain text
      return Text(
        planText,
        style: TextStyle(color: Colors.grey[800], height: 1.5),
      );
    }

    final meals = parsed.meals.take(maxMeals ?? parsed.meals.length).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Meals
        ...meals.map((m) => _mealCard(context, m, compact: compact)).toList(),
        if (!compact) const SizedBox(height: 12),
        if (!compact && parsed.notes != null && parsed.notes!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _notesCard(context, parsed.notes!),
        ],
      ],
    );
  }

  Widget _mealCard(BuildContext context, ParsedMeal meal, {required bool compact}) {
    final chips = <Widget>[];
    if (meal.grams != null) chips.add(_metricChip('Portion', '${meal.grams!.toStringAsFixed(0)} g', Colors.indigo));
    if (meal.calories != null) chips.add(_metricChip('Cal', meal.calories!.toStringAsFixed(0), Colors.orange));
    if (meal.carbs != null) chips.add(_metricChip('Carbs', meal.carbs!.toStringAsFixed(1), Colors.teal));
    if (meal.sugar != null) chips.add(_metricChip('Sugar', meal.sugar!.toStringAsFixed(1), Colors.pink));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: compact ? 18 : 22,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(_mealEmoji(meal.mealType), style: TextStyle(fontSize: compact ? 16 : 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${meal.mealType}: ${meal.name}',
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: compact ? 14 : 16),
                  ),
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(spacing: 6, runSpacing: 6, children: chips);
                      },
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _notesCard(BuildContext context, String notes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📝', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(child: Text(notes, style: TextStyle(color: Colors.grey[800]))),
          ],
        ),
      ),
    );
  }

  Widget _metricChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label: ', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
