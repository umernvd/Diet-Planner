import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../main.dart';
import '../models/user_profile.dart';
import '../services/food_database_service.dart';
import '../widgets/calorie_summary.dart';
import 'log_food_screen.dart';
import 'meal_planner_screen.dart';
import 'progress_screen.dart';
import 'recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _index = 0;
  final _db = FoodDatabaseService.instance;
  final _profile = UserProfile.sample();
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Helper method to build macro nutrient chips
  Widget _buildMacroChip(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(0)}g',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  void _onAddFood(_) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildOverview(context),
      LogFoodScreen(onAdd: _onAddFood),
      const MealPlannerScreen(),
      const ProgressScreen(),
      const RecipeScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: screens[_index],
      ),
      bottomNavigationBar: _buildEnhancedNavigationBar(),
    );
  }
  
  // Enhanced bottom navigation bar with animations and custom styling
  Widget _buildEnhancedNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.restaurant_outlined, Icons.restaurant, 'Log Food'),
              _buildNavItem(2, Icons.calendar_today_outlined, Icons.calendar_today, 'Meal Plan'),
              _buildNavItem(3, Icons.show_chart_outlined, Icons.show_chart, 'Progress'),
              _buildNavItem(4, Icons.menu_book_outlined, Icons.menu_book, 'Recipes'),
            ],
          ),
        ),
      ),
    );
  }
  
  // Individual navigation item with animation
  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _index == index;
    
    return InkWell(
      onTap: () => setState(() => _index = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.textMedium,
              size: isSelected ? 28 : 24,
            )
            .animate(target: isSelected ? 1 : 0)
            .scale(duration: 200.ms, curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            
            const SizedBox(height: 4),
            
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGreen : AppColors.textMedium,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(BuildContext context) {
    final today = DateTime.now();
    final calories = _db.caloriesFor(today);
    final recent = _db.getLoggedFoods(today).reversed.take(5).toList();
    final theme = Theme.of(context);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with gradient background
          SliverAppBar(
            floating: true,
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen.withOpacity(0.8),
                    AppColors.primaryGreen.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'greeting',
                              child: Text(
                                'Hello, ${_profile.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 3.0,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_profile.goal.dailyCalories.toStringAsFixed(0)} kcal daily goal',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Hero(
                        tag: 'avatar',
                        child: Material(
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: const CircleBorder(),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Text(
                              _profile.name[0],
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Spacer
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          
          // Calorie Summary Card with enhanced styling
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CalorieSummary(
                    caloriesConsumed: calories,
                    goalCalories: _profile.goal.dailyCalories,
                    recentFoods: recent,
                  ),
                ),
              ),
            ),
          ),
          
          // Today's Log Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Log',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${today.day}/${today.month}/${today.year}',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Food Log List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: _buildRecentList(),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildRecentList() {
    final today = DateTime.now();
    final logged = _db.getLoggedFoods(today).reversed.toList();

    if (logged.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 70,
                  color: AppColors.primaryGreen.withOpacity(0.7),
                ),
              ).animate().fade(duration: 600.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 24),
              Text(
                'No foods logged today',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
              ).animate().fade(duration: 800.ms, delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                'Track your meals to reach your goals',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ).animate().fade(duration: 800.ms, delay: 300.ms),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => setState(() => _index = 1),
                icon: const Icon(Icons.add),
                label: const Text('Add Food'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
              ).animate().fade(duration: 800.ms, delay: 400.ms).scale(
                    begin: const Offset(0.9, 0.9),
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                    delay: 400.ms,
                  ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        if (i >= logged.length) return null;
        final f = logged[i];
        
        // Calculate percentage of daily calories
        final percentOfDaily = (f.calories / _profile.goal.dailyCalories) * 100;
        final percentText = percentOfDaily.toStringAsFixed(1);
        
        // Determine color based on calorie content
        Color macroColor;
        if (percentOfDaily > 30) {
          macroColor = Colors.redAccent;
        } else if (percentOfDaily > 15) {
          macroColor = Colors.orangeAccent;
        } else {
          macroColor = AppColors.primaryGreen;
        }
        
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (i * 50)),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Circular calorie indicator
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: macroColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          f.calories.toStringAsFixed(0),
                          style: TextStyle(
                            color: macroColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'kcal',
                          style: TextStyle(
                            color: macroColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Food details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Macros row
                      Row(
                        children: [
                          _buildMacroChip('P', f.protein, Colors.blue),
                          const SizedBox(width: 8),
                          _buildMacroChip('C', f.carbs, Colors.orange),
                          const SizedBox(width: 8),
                          _buildMacroChip('F', f.fat, Colors.purple),
                          const SizedBox(width: 8),
                          Text(
                            '$percentText% of daily',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Options button
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: Colors.grey.shade700,
                  onPressed: () async {
                    final today = DateTime.now();
                    // Show bottom sheet with options
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                              onTap: () async {
                                Navigator.pop(context);
                                final nameController = TextEditingController(
                                  text: f.name,
                                );
                                final caloriesController = TextEditingController(
                                  text: f.calories.toStringAsFixed(0),
                                );
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Edit Food'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                          ),
                                        ),
                                        TextField(
                                          controller: caloriesController,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: 'Calories',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                );

                                // Guard against using the State's BuildContext after an async gap
                                if (!mounted) return;

                                if (result == true) {
                                  final newName = nameController.text.trim();
                                  final newCalories =
                                      double.tryParse(caloriesController.text) ??
                                          f.calories;
                                  // Remove the old instance and log the updated one
                                  final removed = _db.removeLoggedFood(today, f);
                                  final updated = f.copyWith(
                                    name: newName.isEmpty ? f.name : newName,
                                    calories: newCalories,
                                  );
                                  _db.logFood(today, updated);
                                  if (removed && mounted) {
                                    setState(() {});
                                    final updatedName = updated.name;
                                    // Store context in local variable to avoid async gap issues
                                    final currentContext = context;
                                    Future.microtask(() {
                                      if (mounted) {
                                        ScaffoldMessenger.of(currentContext).showSnackBar(
                                          SnackBar(
                                            content: Text('Updated $updatedName'),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                }
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () {
                                Navigator.pop(context);
                                final removed = _db.removeLoggedFood(today, f);
                                if (removed) {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Deleted ${f.name}'),
                                      action: SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: () {
                                          _db.logFood(today, f);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}