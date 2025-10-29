import 'dart:collection';

import '../models/food_item.dart';
import 'api_service.dart';

/// In-memory food database and simple logging. Thread-safe-ish for single isolate.
class FoodDatabaseService {
  FoodDatabaseService._privateConstructor();
  static final FoodDatabaseService instance =
      FoodDatabaseService._privateConstructor();

  final List<FoodItem> _foods = [];
  final Map<DateTime, List<FoodItem>> _logs = {};

  UnmodifiableListView<FoodItem> get foods => UnmodifiableListView(_foods);

  void addFood(FoodItem item) {
    if (!_foods.any((f) => f.id == item.id)) _foods.add(item);
  }

  List<FoodItem> search(String query) {
    final q = query.toLowerCase();
    return _foods.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  /// Search remote APIs (OpenFoodFacts) and return normalized FoodItems.
  Future<List<FoodItem>> searchRemote(String query) async {
    try {
      final list = await ApiService.instance.searchFoods(query);
      // add to local cache
      for (final f in list) {
        addFood(f);
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Lookup a food by barcode using remote APIs (OpenFoodFacts). If found,
  /// it's added to the local cache and returned.
  Future<FoodItem?> fetchFoodByBarcode(String barcode) async {
    try {
      final item = await ApiService.instance.fetchFoodByBarcode(barcode);
      if (item != null) addFood(item);
      return item;
    } catch (_) {
      return null;
    }
  }

  void logFood(DateTime date, FoodItem item) {
    final day = DateTime(date.year, date.month, date.day);
    _logs.putIfAbsent(day, () => []).add(item);
    addFood(item);
  }

  /// Remove a single occurrence of [item] from the logs for [date].
  /// Returns true if an item was removed, false otherwise.
  bool removeLoggedFood(DateTime date, FoodItem item) {
    final day = DateTime(date.year, date.month, date.day);
    final list = _logs[day];
    if (list == null || list.isEmpty) return false;
    // Remove only one matching instance (by id if available, else by equality)
    final idx = list.indexWhere((f) => f.id == item.id);
    if (idx == -1) return false;
    list.removeAt(idx);
    if (list.isEmpty) _logs.remove(day);
    return true;
  }

  List<FoodItem> getLoggedFoods(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return List.unmodifiable(_logs[day] ?? []);
  }

  double caloriesFor(DateTime date) {
    final list = getLoggedFoods(date);
    return list.fold(0.0, (s, f) => s + f.calories);
  }
}
