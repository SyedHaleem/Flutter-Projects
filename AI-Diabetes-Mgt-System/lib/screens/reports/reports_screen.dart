import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/meal_plan_widgets.dart';
import '../../services/user_service.dart';


class ReportsScreen extends StatefulWidget {
  final int initialTabIndex;
  const ReportsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserService>(context, listen: false).loadUserData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Reports'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Food Analysis'),
            Tab(text: 'Glucose Readings'),
            Tab(text: 'Meal Plans'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFoodAnalysisTab(),
          _buildGlucoseReadingsTab(),
          _buildMealPlansTab(),
        ],
      ),
    );
  }

  Widget _buildFoodAnalysisTab() {
    return Consumer<UserService>(
      builder: (context, userService, _) {
        final reports = userService.calorieReports;

        if (reports.isEmpty) {
          return _buildEmptyState(
            icon: Icons.restaurant,
            title: 'No Food Analysis Yet',
            subtitle: 'Scan your first food item to see detailed nutritional analysis and glucose impact',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return _buildFoodReportCard(report);
          },
        );
      },
    );
  }

  Widget _buildFoodReportCard(Map<String, dynamic> report) {
    final calories = report['calories'] as double? ?? 0.0;
    final glucoseImpact = report['glucoseImpact'] as double? ?? 0.0;
    final foodName = report['foodName'] as String? ?? 'Unknown Food';
    final description = report['description'] as String? ?? '';
    final dateTime = report['dateTime']?.toDate() as DateTime?;

    Color impactColor = Colors.green;
    
    if (glucoseImpact > 6) {
      impactColor = Colors.red;
    } else if (glucoseImpact > 3) {
      impactColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.restaurant,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (description.isNotEmpty)
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      if (dateTime != null)
                        Text(
                          '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.blue[700]),
                        const SizedBox(height: 4),
                        Text(
                          '${calories.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Text(
                          'Calories',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: impactColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.trending_up, color: impactColor),
                        const SizedBox(height: 4),
                        Text(
                          '${glucoseImpact.toStringAsFixed(1)}/10',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: impactColor,
                          ),
                        ),
                        Text(
                          'Glucose Impact',
                          style: TextStyle(
                            fontSize: 12,
                            color: impactColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlucoseReadingsTab() {
    return Consumer<UserService>(
      builder: (context, userService, _) {
        final readings = userService.sugarReadings;

        if (readings.isEmpty) {
          return _buildEmptyState(
            icon: Icons.trending_up,
            title: 'No Glucose Readings Yet',
            subtitle: 'Start logging your glucose levels to track your progress and identify patterns',
          );
        }

        // Calculate statistics
        final values = readings.map((r) => (r['reading'] as num).toDouble()).toList();
        final average = values.reduce((a, b) => a + b) / values.length;
        final highReadings = values.where((v) => v > 140).length;
        final lowReadings = values.where((v) => v < 70).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Glucose Statistics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Average',
                              average.toStringAsFixed(1),
                              average > 140 ? Colors.red : average < 70 ? Colors.blue : Colors.green,
                            ),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'High Readings',
                              '$highReadings',
                              highReadings > 0 ? Colors.red : Colors.green,
                            ),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              'Low Readings',
                              '$lowReadings',
                              lowReadings > 0 ? Colors.blue : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                'Recent Readings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Readings List
              ...readings.map((reading) => _buildGlucoseReadingCard(reading)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildGlucoseReadingCard(Map<String, dynamic> reading) {
    final value = (reading['reading'] as num).toDouble();
    final dateTime = reading['dateTime']?.toDate() as DateTime?;
    
    Color statusColor = Colors.green;
    String status = 'Normal';
    IconData statusIcon = Icons.check_circle;
    
    if (value < 70) {
      statusColor = Colors.blue;
      status = 'Low';
      statusIcon = Icons.arrow_downward;
    } else if (value > 140) {
      statusColor = Colors.red;
      status = 'High';
      statusIcon = Icons.arrow_upward;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.1),
              child: Icon(statusIcon, color: statusColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${value.toStringAsFixed(1)} mg/dL',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (dateTime != null)
                    Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlansTab() {
    return Consumer<UserService>(
      builder: (context, userService, _) {
        final mealPlan = userService.mealPlan;

        if (mealPlan == null) {
          return _buildEmptyState(
            icon: Icons.restaurant_menu,
            title: 'No Meal Plan Generated',
            subtitle: 'Complete your profile and generate a personalized meal plan based on your health data',
            actionText: 'Generate Meal Plan',
            onAction: () async {
              final profile = userService.userProfile;
              if (profile == null || !(profile['isProfileComplete'] ?? false)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please complete your profile first'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Generating your personalized meal plan...'),
                    ],
                  ),
                ),
              );

              await userService.generateMealPlan();

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meal plan generated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Your Meal Plan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('🍽️', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Updating your meal plan...'),
                                  ],
                                ),
                              ),
                            );

                            await userService.generateMealPlan();

                            if (mounted) {
                              Navigator.pop(context);
                              // Build descriptive snackbar
                              final profile = userService.userProfile;
                              final age = profile?['age'];
                              final weight = profile?['weight'];
                              final reads = userService.sugarReadings.take(3).map((r) => (r['reading'] as num).toDouble()).toList();
                              final readsText = reads.isEmpty ? 'n/a' : reads.map((e) => e.toStringAsFixed(0)).join(', ');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('New AI meal plan generated based on your age ${age ?? '-'}, weight ${weight ?? '-'} kg, and last 3 glucose readings: $readsText'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Update'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MealPlanView(planText: mealPlan),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
