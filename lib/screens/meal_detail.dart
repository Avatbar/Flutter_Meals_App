import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals_app/models/meal_database.dart';
import 'package:meals_app/providers/favorites_provider.dart';

class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({super.key, required this.meal});

  final MealDatabase meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          if (meal.approved)
            IconButton(
              onPressed: () {
                final wasAdded = ref
                    .read((favoriteMealsProvider.notifier))
                    .toggleMealFavoriteStatus(meal);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      wasAdded ? "Meal added as a favorite." : "Meal removed."),
                ));
              },
              icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Not Approved",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
        ],
      ),
      body: ListView(
        children: [
          Image.network(
            meal.imageURL,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            "Ingredients",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 14,
          ),
          ...meal.ingredients
              .map((ingredient) => Text(
                    ingredient,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ))
              .toList(),
          const SizedBox(
            height: 24,
          ),
          Text(
            "Steps",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 14,
          ),
          ...meal.steps
              .map((step) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      step,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
