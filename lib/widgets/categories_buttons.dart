import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoriesButton extends StatefulWidget {
  CategoriesButton(
      {super.key,
      required this.availableCategories,
      required this.selectedCategories,
      required this.setCategories});

  final List<Category> availableCategories;
  final List<bool> selectedCategories;

  void Function (List<bool> selectedCategories) setCategories;

  @override
  State<CategoriesButton> createState() => _CategoriesButtonState();
}

class _CategoriesButtonState extends State<CategoriesButton> {
  @override
  void initState() {
    super.initState();
    for (final _ in widget.availableCategories) {
      widget.selectedCategories.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.setCategories(widget.selectedCategories);
    return Column(
      children: [
        for (int i = 0; i < widget.availableCategories.length; i += 4)
          ToggleButtons(
              onPressed: (int index) {
                index += i;
                setState(() {
                  widget.selectedCategories[index] =
                      !widget.selectedCategories[index];
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
              isSelected: (i + 4) < widget.selectedCategories.length
                  ? widget.selectedCategories.sublist(i, i + 4)
                  : widget.selectedCategories.sublist(i),
              children: <Widget>[
                for (final category
                    in (i + 4) < widget.availableCategories.length
                        ? widget.availableCategories.sublist(i, i + 4)
                        : widget.availableCategories.sublist(i))
                  Text(category.title),
              ]),
      ],
    );
  }
}
