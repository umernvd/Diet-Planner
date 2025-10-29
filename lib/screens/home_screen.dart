import 'package:flutter/material.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _db = FoodDatabaseService.instance;
  final _profile = UserProfile.sample();

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
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOutCubic,
        child: screens[_index],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined),
            selectedIcon: Icon(Icons.add),
            label: 'Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Recipes',
          ),
        ],
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
        slivers: [
          SliverAppBar(
            floating: true,
            toolbarHeight: 80,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 48,
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
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_profile.goal.dailyCalories.toStringAsFixed(0)} kcal goal',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: 'avatar',
                      child: Material(
                        elevation: 2,
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            _profile.name[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CalorieSummary(
                caloriesConsumed: calories,
                goalCalories: _profile.goal.dailyCalories,
                recentFoods: recent,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Today\'s Log',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: _buildRecentList(),
          ),
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
              Icon(Icons.restaurant, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No foods logged today',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => setState(() => _index = 1),
                icon: const Icon(Icons.add),
                label: const Text('Add Food'),
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
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (i * 50)),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              f.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${f.calories.toStringAsFixed(0)} kcal · P: ${f.protein}g · C: ${f.carbs}g · F: ${f.fat}g',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
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
                              if (removed) {
                                setState(() {});
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                    content: Text('Updated ${updated.name}'),
                                  ),
                                );
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
          ),
        );
      }),
    );
  }
}
