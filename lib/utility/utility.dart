import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/meal_database.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class Utility {
  MealDatabase crateMeal(QueryDocumentSnapshot<Object?> doc) {
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
    actMeal.approved = doc['approved'];
    return actMeal;
  }

  Future<List<MealDatabase>> getMealsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final meals = <MealDatabase>[];

    for (var doc in snapshot.docs) {
      meals.add(crateMeal(doc));
    }

    if (meals.isEmpty) {
      return <MealDatabase>[];
    }
    return meals;
  }

  Future<List<MealDatabase>> getMealsFromDatabase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Meals')
        .where('approved', isEqualTo: true)
        .get();
    return getMealsFromSnapshot(snapshot);
  }

  Future<List<MealDatabase>> getFilteredMealsFromDatabase() async {
    final activeFilters = await getActiveFilters();
    final snapshot = await FirebaseFirestore.instance
        .collection('Meals')
        .where('isGlutenFree',
            isEqualTo: activeFilters[Filter.glutenFree]! ? true : null)
        .where('isLactoseFree',
            isEqualTo: activeFilters[Filter.lactoseFree]! ? true : null)
        .where('isVegetarian',
            isEqualTo: activeFilters[Filter.vegetarian]! ? true : null)
        .where('isVegan', isEqualTo: activeFilters[Filter.vegan]! ? true : null)
        .get();

    return getMealsFromSnapshot(snapshot);
  }

  Future<Map<Filter, bool>> getActiveFilters() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return {
      Filter.glutenFree: snapshot.get('glutenFree'),
      Filter.lactoseFree: (snapshot).get('lactoseFree'),
      Filter.vegetarian: (snapshot).get('vegetarian'),
      Filter.vegan: (snapshot).get('vegan'),
    };
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
    String imageUrl = meal.imageURL;

    if (meal.image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("meal_image")
          .child("${meal.title}${meal.creatorID}.jpg");

      await ref.putFile(meal.image!);
      imageUrl = await ref.getDownloadURL();
    }

    try {
      await FirebaseFirestore.instance.collection('Meals').doc(meal.id).update({
        'title': meal.title,
        'image': imageUrl,
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

  String getAffordabilityText(QueryDocumentSnapshot<Object?> doc) {
    switch (doc['affordability'].toString().parseAffordability()) {
      case Affordability.affordable:
        return '€';
      case Affordability.pricey:
        return '€€';
      case Affordability.luxurious:
        return '€€€';
    }
  }

  Future<List<MealDatabase>> getFavoriteMealsFromDatabase() async {
    final favoriteSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final favoriteMealsId = <String>[];

    for (var doc in favoriteSnapshot['userFavoriteMeals']){
      favoriteMealsId.add(doc);
    }

    if (favoriteMealsId.isEmpty) {
      return <MealDatabase>[];
    }

    final mealSnapshot = await FirebaseFirestore.instance
        .collection('Meals')
        .where('id', whereIn: favoriteMealsId)
        .get();

    return getMealsFromSnapshot(mealSnapshot);
  }
}
