import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/user_profile.dart';
import '../../models/food_analysis.dart';
import '../../models/meal_plan.dart';

class FoodAnalysisScreen extends StatefulWidget {
	final Uint8List imageBytes;
	final UserProfile profile;
	const FoodAnalysisScreen({super.key, required this.imageBytes, required this.profile});

	@override
	State<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
	FoodAnalysis? analysis;
	MealAndLifestylePlan? plan;
	bool loading = true;
	String? error;

	final _isCooked = ValueNotifier<bool>(true);
	String _cookingMethod = 'grilled';
	final _oilController = TextEditingController(text: '1 tbsp');
	final _portionHintController = TextEditingController(text: 'medium');

	@override
	void initState() {
		super.initState();
		_run();
	}

	Future<void> _run() async {
		setState(()=> loading = true);
		final ai = AIService();
		try {
			final result = await ai.fullFlow(
				imageBytes: widget.imageBytes,
				isCooked: _isCooked.value,
				cookingMethod: _cookingMethod,
				oilEstimate: _oilController.text,
				portionHint: _portionHintController.text,
				profile: widget.profile,
			);
			setState(() { analysis = result.$1; plan = result.$2; error = null; });
		} catch (e) {
			setState(()=> error = e.toString());
		} finally { setState(()=> loading = false); }
	}

	Future<void> _editPortion() async {
		if (analysis == null) return;
		final controller = TextEditingController(text: analysis!.estimatedPortionGrams.toString());
		final newNameController = TextEditingController(text: analysis!.foodName);
		final res = await showDialog<(int,String)?>(context: context, builder: (c)=> AlertDialog(
			title: const Text('Edit Portion / Name'),
			content: Column(mainAxisSize: MainAxisSize.min, children:[
				TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Portion grams')), 
				TextField(controller: newNameController, decoration: const InputDecoration(labelText: 'Food name')), 
			]),
			actions:[ TextButton(onPressed: ()=> Navigator.pop(c), child: const Text('Cancel')), ElevatedButton(onPressed: (){ final g = int.tryParse(controller.text); if(g==null){return;} Navigator.pop(c,(g,newNameController.text));}, child: const Text('Apply')) ],
		));
		if (res == null) return;
		setState(()=> loading = true);
		final ai = AIService();
		try {
			// Recompute USDA + risk + meal plan without image call
			var updated = analysis!.copyWith(estimatedPortionGrams: res.$1, foodName: res.$2);
			final nutrition = await ai.enrichWithUSDA(updated);
			if (nutrition != null) {
				final risk = ai.classifyRisk(nutrition.carbs, nutrition.sugar);
				updated = updated.copyWith(nutrition: nutrition, glucoseRisk: risk);
				final newPlan = await ai.generateMealPlan(profile: widget.profile, analysis: updated);
			await ai.storeHistory(analysis: updated, plan: newPlan);
			setState((){analysis = updated; plan = newPlan;});
			} else {
				setState(()=> analysis = updated);
			}
		} catch (e) { setState(()=> error = e.toString()); }
		finally { setState(()=> loading = false); }
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Food Analysis'), actions:[ if(analysis!=null) IconButton(onPressed: _editPortion, icon: const Icon(Icons.edit)) ]),
			body: loading ? const Center(child: CircularProgressIndicator()) : error!=null ? Center(child: Text(error!)) : _body(),
		);
	}

	Widget _body() {
		if (analysis == null) return const Center(child: Text('No analysis'));
		return ListView(
			padding: const EdgeInsets.all(16),
			children: [
				Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
					Text(analysis!.foodName, style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
					const SizedBox(height:8),
					Text('Portion: ${analysis!.estimatedPortionGrams} g'),
					Text('Confidence: ${(analysis!.confidence*100).toStringAsFixed(1)}%'),
					Text('Risk: ${analysis!.glucoseRisk}', style: TextStyle(color: _riskColor(analysis!.glucoseRisk), fontWeight: FontWeight.bold)),
				]))),
				if (analysis!.nutrition != null) Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
					const Text('Nutrition (portion)', style: TextStyle(fontWeight: FontWeight.bold)),
					Text('Calories: ${analysis!.nutrition!.calories.toStringAsFixed(1)}'),
					Text('Carbs: ${analysis!.nutrition!.carbs.toStringAsFixed(1)} g'),
					Text('Sugar: ${analysis!.nutrition!.sugar.toStringAsFixed(1)} g'),
					Text('Fiber: ${analysis!.nutrition!.fiber.toStringAsFixed(1)} g'),
					Text('Protein: ${analysis!.nutrition!.protein.toStringAsFixed(1)} g'),
					Text('Fat: ${analysis!.nutrition!.fat.toStringAsFixed(1)} g'),
				]))),
				Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
					const Text('Ingredients'),
					...analysis!.ingredients.map((e)=> Text('- $e')),
				]))),
				if (plan != null) Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
					const Text('Meal Plan', style: TextStyle(fontWeight: FontWeight.bold)),
					...plan!.mealPlan.map((m)=> ListTile(title: Text('${m.mealType}: ${m.name}'), subtitle: Text('${m.portionGrams} g  C:${m.carbs}  S:${m.sugar}  Cal:${m.calories}'))),
					if (plan!.notes.isNotEmpty) ...[
						const Divider(),
						const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
						Text(plan!.notes),
					],
				]))),
			],
		);
	}

	Color _riskColor(String r) {
		switch(r){
			case 'High': return Colors.red;
			case 'Moderate': return Colors.orange;
			case 'Low': return Colors.green;
			default: return Colors.grey;
		}
	}
}
