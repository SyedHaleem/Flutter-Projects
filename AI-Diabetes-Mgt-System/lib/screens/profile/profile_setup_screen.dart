import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/ai_service.dart';

class ProfileSetupScreen extends StatefulWidget {
	const ProfileSetupScreen({super.key});

	@override
	State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
	final _formKey = GlobalKey<FormState>();
	final _ageController = TextEditingController();
	final _weightController = TextEditingController();
	final _sugar1Controller = TextEditingController();
	final _sugar2Controller = TextEditingController();
	final _sugar3Controller = TextEditingController();
	String _gender = 'Male';
	bool _saving = false;

	@override
	void dispose() {
		_ageController.dispose();
		_weightController.dispose();
		_sugar1Controller.dispose();
		_sugar2Controller.dispose();
		_sugar3Controller.dispose();
		super.dispose();
	}

	Future<void> _save() async {
		if (!_formKey.currentState!.validate()) return;
		setState(() => _saving = true);
		final readings = [
			double.parse(_sugar1Controller.text),
			double.parse(_sugar2Controller.text),
			double.parse(_sugar3Controller.text),
		];
		final profile = UserProfile(
			age: int.parse(_ageController.text),
			gender: _gender,
			weight: double.parse(_weightController.text),
			lastSugarReadings: readings,
		);
		final ai = AIService();
		await ai.saveUserProfile(profile);
		if (mounted) {
			setState(() => _saving = false);
			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
			Navigator.pop(context, profile);
		}
	}

	InputDecoration _dec(String label) => InputDecoration(labelText: label, border: const OutlineInputBorder());

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Profile Setup')),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(16),
				child: Form(
					key: _formKey,
					child: Column(
						children: [
							TextFormField(
								controller: _ageController,
								keyboardType: TextInputType.number,
								decoration: _dec('Age'),
								validator: (v) => v==null||v.isEmpty? 'Enter age': null,
							),
							const SizedBox(height:12),
							DropdownButtonFormField<String>(
								value: _gender,
								items: const [DropdownMenuItem(value:'Male',child:Text('Male')),DropdownMenuItem(value:'Female',child:Text('Female')),DropdownMenuItem(value:'Other',child:Text('Other'))],
								onChanged: (v)=> setState(()=> _gender=v!),
								decoration: _dec('Gender'),
							),
							const SizedBox(height:12),
							TextFormField(
								controller: _weightController,
								keyboardType: TextInputType.number,
								decoration: _dec('Weight (kg)'),
								validator: (v)=> v==null||v.isEmpty? 'Enter weight': null,
							),
							const SizedBox(height:20),
							const Align(alignment: Alignment.centerLeft, child: Text('Last 3 days sugar readings (mg/dL)', style: TextStyle(fontWeight: FontWeight.bold))),
							const SizedBox(height:12),
							Row(children:[
								Expanded(child: TextFormField(controller:_sugar1Controller,keyboardType: TextInputType.number,decoration:_dec('Day 1'),validator:(v)=> v==null||v.isEmpty? 'Req':null)),
								const SizedBox(width:8),
								Expanded(child: TextFormField(controller:_sugar2Controller,keyboardType: TextInputType.number,decoration:_dec('Day 2'),validator:(v)=> v==null||v.isEmpty? 'Req':null)),
								const SizedBox(width:8),
								Expanded(child: TextFormField(controller:_sugar3Controller,keyboardType: TextInputType.number,decoration:_dec('Day 3'),validator:(v)=> v==null||v.isEmpty? 'Req':null)),
							]),
							const SizedBox(height:30),
							SizedBox(width: double.infinity, height:50, child: ElevatedButton(
								onPressed: _saving? null: _save,
								child: _saving? const CircularProgressIndicator(color:Colors.white): const Text('Save Profile'),
							))
						],
					),
				),
			),
		);
	}
}
