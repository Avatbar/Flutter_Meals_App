import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/meal_database.dart';

class Utility {
  Future<List<MealDatabase>> getMealsFromDatabase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Meals')
        .orderBy('title')
        .get();

    final meals = <MealDatabase>[];

    for (var doc in snapshot.docs) {
      List<String> categories = [];
      for (var category in doc['categories']) {
        categories.add(category.toString());
      }
      List<String> ingredients = [];
      for (var ingredient in doc['ingredients']) {
        ingredients.add(ingredient.toString());
      }
      List<String> steps = [];
      for (var step in doc['steps']) {
        steps.add(step.toString());
      }
      final actMeal = MealDatabase(
        id: doc.id,
        title: doc['title'],
        duration: doc['duration'],
        ingredients: ingredients,
        steps: steps,
        categories: categories,
        complexity: doc['complexity'].toString().parseComplexity(),
        affordability: doc['affordability'].toString().parseAffordability(),
        isGlutenFree: doc['isGlutenFree'],
        isLactoseFree: doc['isLactoseFree'],
        isVegan: doc['isVegan'],
        isVegetarian: doc['isVegetarian'],
        creatorID: doc['creatorID'],
      );
      actMeal.setImageURL(doc['image']);
      meals.add(actMeal);
    }

    if (meals.isEmpty) {
      return <MealDatabase>[];
    }
    return meals;
  }

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

  Future<bool> uploadMeal(MealDatabase meal) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("meal_image")
        .child("${meal.title}${meal.creatorID}.jpg");

    await ref.putFile(meal.image!);

    try {
      await FirebaseFirestore.instance.collection('Meals').add({
        'title': meal.title,
        'image': await ref.getDownloadURL(),
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

  Future<bool> uploadCategory(Category category) async {
    try {
      await FirebaseFirestore.instance.collection('Categories').add({
        'title': category.title,
        'color': category.color.value.toString(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editMeal(MealDatabase meal) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("meal_image")
        .child("${meal.title}${meal.creatorID}.jpg");

    await ref.putFile(meal.image!);

    try {
      await FirebaseFirestore.instance.collection('Meals').doc(meal.id).update({
        'title': meal.title,
        'image': ref.getDownloadURL(),
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
