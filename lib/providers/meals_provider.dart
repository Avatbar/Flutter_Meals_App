import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal_database.dart';

import '../utility/utility.dart';

class MealsNotifier extends StateNotifier<List<MealDatabase>> {
  MealsNotifier() : super([]) {
    Utility().getMealsFromDatabase().then((value) => state = value);
  }
}

final mealsProvider = StateNotifierProvider<MealsNotifier, List<MealDatabase>>((ref) {
  return MealsNotifier();
});