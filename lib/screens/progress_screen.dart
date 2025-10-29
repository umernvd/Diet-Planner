import 'package:flutter/material.dart';

import '../services/food_database_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FoodDatabaseService.instance;
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: i)));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: days.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final d = days[i];
                  final cals = db.caloriesFor(d);
                  return ListTile(
                    title: Text('${d.month}/${d.day}/${d.year}'),
                    trailing: Text('${cals.toStringAsFixed(0)} kcal'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
