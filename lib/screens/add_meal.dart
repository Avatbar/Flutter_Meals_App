import 'package:flutter/material.dart';

import 'package:meals_app/widgets/new_meal_form.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("New Meal",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            NewMealForm(),
          ],
        ),
      ),
    );
  }
}
