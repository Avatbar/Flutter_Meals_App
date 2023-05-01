import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

import '../screens/tabs.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}


class FilterNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterNotifier() : super(kInitialFilter) {
    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => state = {
      Filter.glutenFree: value.data()!['glutenFree'] as bool,
      Filter.lactoseFree: value.data()!['lactoseFree'] as bool,
      Filter.vegetarian: value.data()!['vegetarian'] as bool,
      Filter.vegan: value.data()!['vegan'] as bool,
    });
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setFilters() {
    FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'glutenFree': state[Filter.glutenFree],
      'lactoseFree': state[Filter.lactoseFree],
      'vegetarian': state[Filter.vegetarian],
      'vegan': state[Filter.vegan],
    });
  }
}

final filtersProvider =
    StateNotifierProvider<FilterNotifier, Map<Filter, bool>>(
        (ref) => FilterNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
