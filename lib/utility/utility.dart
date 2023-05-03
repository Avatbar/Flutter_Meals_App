import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';

import '../models/meal_database.dart';

class Utility {
  Future<List<Category>> getCategoriesFromDatabase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .orderBy('title')
        .get();

    final categories = <Category>[];

    for (var doc in snapshot.docs) {
      categories.add(Category(
        id: doc.id,
        title: doc['title'],
        color: Color(int.parse(doc['color'])),
      ));
    }

    if (categories.isEmpty) {
      return <Category>[];
    }

    return categories;
  }

  bool uploadMeal(MealDatabase meal) {
    try {
      FirebaseFirestore.instance.collection('Meals').add({
        'title': meal.title,
        'image': meal.image,
        'duration': meal.duration,
        'ingredients': meal.ingredients,
        'steps': meal.steps,
        'categories': meal.categories,
        'complexity': meal.complexity.stringify(),
        'affordability': meal.affordability.stringify(),
        'isGlutenFree': meal.isGlutenFree,
        'isLactoseFree': meal.isLactoseFree,
        'isVegan': meal.isVegan,
        'isVegetarian': meal.isVegetarian,
        'approved': meal.approved,
        'creatorID': meal.creatorID,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  bool editMeal(MealDatabase meal) {
    try {
      FirebaseFirestore.instance.collection('Meals').doc(meal.id).update({
        'title': meal.title,
        'image': meal.image,
        'duration': meal.duration,
        'ingredients': meal.ingredients,
        'steps': meal.steps,
        'categories': meal.categories,
        'complexity': meal.complexity.stringify(),
        'affordability': meal.affordability.stringify(),
        'isGlutenFree': meal.isGlutenFree,
        'isLactoseFree': meal.isLactoseFree,
        'isVegan': meal.isVegan,
        'isVegetarian': meal.isVegetarian,
        'approved': meal.approved,
        'creatorID': meal.creatorID,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}