import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal_database.dart';

import '../utility/utility.dart';

final mealsProvider = Provider((ref) async {
  final List<MealDatabase> availableMeals = await Utility().getMealsFromDatabase();
  return availableMeals;
});
