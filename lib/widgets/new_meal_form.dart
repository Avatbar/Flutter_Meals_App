import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utility/utility.dart';
import 'categories_buttons.dart';
import 'complex_afford_buttons.dart';

class NewMealForm extends StatefulWidget {
  const NewMealForm({super.key});

  @override
  State<NewMealForm> createState() => _NewMealFormState();
}

class _NewMealFormState extends State<NewMealForm> {
  final _availableCategories = Utility().getCategoriesFromDatabase();

  Future<List<Category>> waitForCategories() async{
    return await _availableCategories;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            const ComplexAffordButtons(),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              decoration: const InputDecoration(labelText: "Title"),
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
            ),
            TextFormField(
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              decoration: const InputDecoration(labelText: "Steps"),
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            TextFormField(
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              decoration: const InputDecoration(labelText: "Duration"),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Select Categories"),
            CategoriesButton(
              availableCategories: _availableCategories),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Add Meal"),
            ),
          ],
        ),
      ),
    );
  }
}
