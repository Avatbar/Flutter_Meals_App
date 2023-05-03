import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utility/utility.dart';
import 'categories_buttons.dart';
import 'complex_afford_buttons.dart';
import 'package:meals_app/pickers/user_image_picker.dart';

class NewMealForm extends StatefulWidget {
  const NewMealForm({super.key});

  @override
  State<NewMealForm> createState() => _NewMealFormState();
}

class _NewMealFormState extends State<NewMealForm> {
  final List<bool> selectedCategories = [];
  final Map<Category, bool> selectedCategoriesMap = {};
  String title = "";
  List<String> ingredients = [];
  List<String> steps = [];
  int duration = 0;
  late File? _userImageFile;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  bool _hasImage() {
    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please pick an image."),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return false;
    }
    return true;
  }

  bool _hasCategories() {
    if (!selectedCategories.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please pick at least one category."),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return false;
    }
    return true;
  }

  void _mapCategoires() async{
    final categories = await Utility().getCategoriesFromDatabase();
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong."),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final Map<int, Category> categoryIntMap = {};
    for (int i = 0; i < categories.length; i++) {
      categoryIntMap[i] = categories[i];
    }

    for (int i = 0; i < selectedCategories.length; i++) {
      selectedCategoriesMap[categoryIntMap[i]!] = selectedCategories[i];
    }
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    if (!_hasImage() || !_hasCategories()) {
      return;
    }

    _mapCategoires();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utility().getCategoriesFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                UserImagePicker(imagePickFn: _pickedImage),
                const SizedBox(
                  height: 30,
                ),
                const ComplexAffordButtons(),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a title.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value!;
                  },
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  decoration: const InputDecoration(labelText: "Ingredients"),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter ingredients.";
                    }
                    if (value.split(",").length < 3) {
                      return "Please enter at least 3 ingredients.";
                    }
                    if (!value.contains(',')) {
                      return "Please enter ingredients separated by commas.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ingredients = value!.split(",");
                  },
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  decoration: const InputDecoration(labelText: "Steps"),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter steps.";
                    }
                    if (value.split("\n").length < 3) {
                      return "Please enter at least 3 steps.";
                    }
                    if (!value.contains('\n')) {
                      return "Please enter steps separated by new lines (enter).";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    steps = value!.split("\n");
                  },
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  decoration: const InputDecoration(labelText: "Duration"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a duration.";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    if (int.parse(value) <= 0) {
                      return "Please enter a number greater than 0.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    duration = int.parse(value!);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Select Categories",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CategoriesButton(
                    availableCategories: snapshot.data as List<Category>,
                    selectedCategories: selectedCategories),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print(selectedCategoriesMap);
                  },
                  child: const Text("Add Meal"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
