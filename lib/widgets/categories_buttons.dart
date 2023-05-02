import 'package:flutter/material.dart';

import '../models/category.dart';
import '../data/dummy_data.dart';

class CategoriesButton extends StatefulWidget {
  const CategoriesButton(
      {super.key, required this.availableCategories});

  final Future<List<Category>> availableCategories;

  @override
  State<CategoriesButton> createState() => _CategoriesButtonState();
}

class _CategoriesButtonState extends State<CategoriesButton> {
  final selectedCategories = [
    for (final _ in availableCategories) false
  ];

  void _selectCategory(int index) {
    setState(() {
      selectedCategories[index] = !selectedCategories[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < selectedCategories.length; i++) {
              _selectCategory(i);
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: Colors.green[700],
        selectedColor: Colors.white,
        fillColor: Colors.green[200],
        color: Colors.green[400],
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: selectedCategories,
        children: <Widget>[
          for (final category in availableCategories)
            Text(category.title),
        ]
    );
  }
}
