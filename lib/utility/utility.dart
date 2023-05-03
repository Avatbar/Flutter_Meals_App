import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';

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

  bool uploadMeal(
      {required String title,
      required List<String> ingredients,
      required List<String> steps,
      required int duration,
      required File image,
      required List<Category> categories},
      required
  ) {
    try {
      FirebaseFirestore.instance.collection('Meals').add({
        'title': title,
        'ingredients': ingredients,
        'steps': steps,
        'duration': duration,
        'image': image,
        'categories': categories,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}