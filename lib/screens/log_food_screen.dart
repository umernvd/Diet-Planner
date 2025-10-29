import 'package:flutter/material.dart';

import '../models/food_item.dart';
import '../services/barcode_scanner_service.dart';
import '../services/food_database_service.dart';
import '../widgets/food_search.dart';

class LogFoodScreen extends StatefulWidget {
  final void Function(FoodItem) onAdd;

  const LogFoodScreen({super.key, required this.onAdd});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  final _scanner = BarcodeScannerService();
  final _db = FoodDatabaseService.instance;
  bool _scanning = false;

  Future<void> _scanAndLookup() async {
    setState(() => _scanning = true);
    final code = await _scanner.scanBarcode();
    setState(() => _scanning = false);
    if (code == null) {
      if (!mounted) return;
      // Safe to use context after mounted check
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No barcode scanned')));
      return;
    }

    // Lookup remote
    final item = await _db.fetchFoodByBarcode(code);
    if (!mounted) return;
    if (item == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No product found for barcode $code')),
      );
      return;
    }

    // Show preview and option to add
    final added = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Text(
          '${item.calories.toStringAsFixed(0)} kcal · ${item.servingSizeGrams.toStringAsFixed(0)} g\nP: ${item.protein}g · C: ${item.carbs}g · F: ${item.fat}g',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (added == true) {
      if (!mounted) return;
      final now = DateTime.now();
      _db.logFood(now, item);
      widget.onAdd(item);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added ${item.name}')));
    }
  }

  Future<void> _showAddCustomDialog() async {
    final nameCtrl = TextEditingController();
    final caloriesCtrl = TextEditingController();
    final proteinCtrl = TextEditingController();
    final carbsCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    final servingCtrl = TextEditingController(text: '100');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Food'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: caloriesCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Calories'),
              ),
              TextField(
                controller: proteinCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Protein (g)'),
              ),
              TextField(
                controller: carbsCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
              ),
              TextField(
                controller: fatCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Fat (g)'),
              ),
              TextField(
                controller: servingCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Serving size (g)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final name = nameCtrl.text.trim();
    final calories = double.tryParse(caloriesCtrl.text) ?? 0.0;
    final protein = double.tryParse(proteinCtrl.text) ?? 0.0;
    final carbs = double.tryParse(carbsCtrl.text) ?? 0.0;
    final fat = double.tryParse(fatCtrl.text) ?? 0.0;
    final serving = double.tryParse(servingCtrl.text) ?? 100.0;

    if (name.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }

    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final item = FoodItem(
      id: id,
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      servingSizeGrams: serving,
    );
    final now = DateTime.now();
    _db.logFood(now, item);
    if (!mounted) return;
    widget.onAdd(item);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Added $name')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: const Text('Log Food'),
              actions: [
                IconButton(
                  icon: _scanning
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.qr_code_scanner),
                  onPressed: _scanning ? null : _scanAndLookup,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FoodSearch(onAdd: widget.onAdd),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCustomDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Custom Food'),
      ),
    );
  }
}
