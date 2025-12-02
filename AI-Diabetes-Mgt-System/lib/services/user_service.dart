import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/user_profile.dart';
import '../models/food_analysis.dart';
import '../models/meal_plan.dart';
import '../services/ai_service.dart';

class UserService extends ChangeNotifier {
  // Update a glucose reading by its document ID
  Future<void> updateSugarReading(String id, double newReading) async {
    try {
      await _firestore.collection('sugar_readings').doc(id).update({
        'reading': newReading,
        'dateTime': FieldValue.serverTimestamp(),
      });
      await loadSugarReadings();
    } catch (e) {
      print('Error updating sugar reading: $e');
    }
  }

  // Delete a glucose reading by its document ID
  Future<void> deleteSugarReading(String id) async {
    try {
      await _firestore.collection('sugar_readings').doc(id).delete();
      await loadSugarReadings();
    } catch (e) {
      print('Error deleting sugar reading: $e');
    }
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? get userProfile => _userProfile;

  List<Map<String, dynamic>> _sugarReadings = [];
  List<Map<String, dynamic>> get sugarReadings => _sugarReadings;

  List<Map<String, dynamic>> _calorieReports = [];
  List<Map<String, dynamic>> get calorieReports => _calorieReports;

  String? _mealPlan;
  String? get mealPlan => _mealPlan;

  Future<void> updateUserProfile({
    required int age,
    required String gender,
    required double weight,
    required String healthHistory,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final profileData = {
        'age': age,
        'gender': gender,
        'weight': weight,
        'healthHistory': healthHistory,
        'isProfileComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(userId).update(profileData);
      await loadUserProfile();
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _userProfile = doc.data();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> addSugarReading(double reading, DateTime dateTime) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final sugarReading = {
        'reading': reading,
        'dateTime': Timestamp.fromDate(dateTime),
        'userId': userId,
      };

      await _firestore.collection('sugar_readings').add(sugarReading);
      await loadSugarReadings();
    } catch (e) {
      print('Error adding sugar reading: $e');
    }
  }

  Future<void> loadSugarReadings() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      try {
        final query = await _firestore
            .collection('sugar_readings')
            .where('userId', isEqualTo: userId)
            .orderBy('dateTime', descending: true)
            .limit(10)
            .get();

        _sugarReadings = query.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      } catch (e) {
        // Fallback if composite index is missing: fetch a few docs and sort client-side.
        final query = await _firestore
            .collection('sugar_readings')
            .where('userId', isEqualTo: userId)
            .limit(10)
            .get();
        _sugarReadings = query.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList()
          ..sort((a, b) {
            final ta = a['dateTime'];
            final tb = b['dateTime'];
            if (ta is Timestamp && tb is Timestamp) {
              return tb.compareTo(ta); // desc
            }
            return 0;
          });
      }

      notifyListeners();
    } catch (e) {
      print('Error loading sugar readings: $e');
    }
  }

  Future<void> addCalorieReport({
    required String foodName,
    required double calories,
    required double glucoseImpact,
    required String? imageUrl,
    required String? description,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final calorieReport = {
        'foodName': foodName,
        'calories': calories,
        'glucoseImpact': glucoseImpact,
        'imageUrl': imageUrl,
        'description': description,
        'dateTime': FieldValue.serverTimestamp(),
        'userId': userId,
      };

      await _firestore.collection('calorie_reports').add(calorieReport);
      await loadCalorieReports();
    } catch (e) {
      print('Error adding calorie report: $e');
    }
  }

  Future<void> loadCalorieReports() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      try {
        final query = await _firestore
            .collection('calorie_reports')
            .where('userId', isEqualTo: userId)
            .orderBy('dateTime', descending: true)
            .limit(10)
            .get();

        _calorieReports = query.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      } catch (e) {
        // Fallback if composite index is missing: fetch and sort client-side.
        final query = await _firestore
            .collection('calorie_reports')
            .where('userId', isEqualTo: userId)
            .limit(10)
            .get();
        _calorieReports = query.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList()
          ..sort((a, b) {
            final ta = a['dateTime'];
            final tb = b['dateTime'];
            if (ta is Timestamp && tb is Timestamp) {
              return tb.compareTo(ta); // desc
            }
            return 0;
          });
      }

      notifyListeners();
    } catch (e) {
      print('Error loading calorie reports: $e');
    }
  }

  Future<void> generateMealPlan() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null || _userProfile == null) return;

      // Get recent sugar readings (last 3)
      final recentReadings = _sugarReadings.take(3).map((r) => (r['reading'] as num).toDouble()).toList();
      final age = (_userProfile!['age'] ?? 0) is int ? _userProfile!['age'] : int.tryParse(_userProfile!['age']?.toString() ?? '0') ?? 0;
      final gender = (_userProfile!['gender'] ?? 'Unknown').toString();
      final weight = (_userProfile!['weight'] is num) ? (_userProfile!['weight'] as num).toDouble() : double.tryParse(_userProfile!['weight']?.toString() ?? '0') ?? 0.0;
      final userProfile = UserProfile(age: age, gender: gender, weight: weight, lastSugarReadings: recentReadings);

      // Use AIService to generate a real meal plan
      final ai = AIService();
      // Use a dummy FoodAnalysis for meal plan generation (since only profile is needed)
      // We'll use a placeholder food with low risk and zero nutrition
      final dummyAnalysis = FoodAnalysis(
        foodName: 'Personalized Plan',
        ingredients: [],
        preparation: '',
        estimatedPortionGrams: 0,
        confidence: 1.0,
        possibleFoodNames: [],
        glucoseRisk: 'Low',
        nutrition: NutritionFacts(
          calories: 0,
          carbs: 0,
          sugar: 0,
          fiber: 0,
          protein: 0,
          fat: 0,
          portionGrams: 0,
          per100gCalories: 0,
        ),
      );
  final plan = await ai.generateMealPlan(profile: userProfile, analysis: dummyAnalysis, forceNew: true);
      final planText = _formatMealPlan(plan);

      final mealPlanData = {
        'mealPlan': planText,
        'generatedAt': FieldValue.serverTimestamp(),
        'userId': userId,
        'userAge': age,
        'userWeight': weight,
        'userGender': gender,
        'recentReadings': recentReadings,
        'source': 'ai',
      };

      await _firestore.collection('meal_plans').add(mealPlanData);
      _mealPlan = planText;
      notifyListeners();
    } catch (e) {
      print('Error generating meal plan: $e');
    }
  }

  String _formatMealPlan(MealAndLifestylePlan plan) {
    final b = StringBuffer();
    b.writeln('AI Meal Plan');
    b.writeln('');
    for (final m in plan.mealPlan) {
      b.writeln('- ${m.mealType}: ${m.name} • ${m.portionGrams}g • Cal ${m.calories.toStringAsFixed(0)} • C ${m.carbs.toStringAsFixed(1)} • S ${m.sugar.toStringAsFixed(1)}');
    }
  b.writeln('');
    if (plan.notes.isNotEmpty) {
      b.writeln('');
      b.writeln('Notes: ${plan.notes}');
    }
    return b.toString();
  }

  // Persist AI-generated meal plan plain text for display in Reports
  Future<void> saveAiMealPlanText(String planText) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('meal_plans').add({
        'mealPlan': planText,
        'generatedAt': FieldValue.serverTimestamp(),
        'userId': userId,
        'source': 'ai',
      });
      _mealPlan = planText;
      notifyListeners();
    } catch (e) {
      print('Error saving AI meal plan: $e');
    }
  }

  Future<void> loadUserData() async {
    await loadUserProfile();
    await loadSugarReadings();
    await loadCalorieReports();
    // Load most recent meal plan text
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        try {
          final q = await _firestore
              .collection('meal_plans')
              .where('userId', isEqualTo: userId)
              .orderBy('generatedAt', descending: true)
              .limit(1)
              .get();
          if (q.docs.isNotEmpty) {
            _mealPlan = q.docs.first.data()['mealPlan'] as String?;
          }
        } catch (e) {
          // Fallback if composite index is missing.
          final q = await _firestore
              .collection('meal_plans')
              .where('userId', isEqualTo: userId)
              .limit(5)
              .get();
          if (q.docs.isNotEmpty) {
            final docs = q.docs.toList()
              ..sort((a, b) {
                final ta = a.data()['generatedAt'];
                final tb = b.data()['generatedAt'];
                if (ta is Timestamp && tb is Timestamp) {
                  return tb.compareTo(ta); // desc
                }
                return 0;
              });
            _mealPlan = docs.first.data()['mealPlan'] as String?;
          }
        }
      }
    } catch (e) {
      // ignore
    }
  }
}
