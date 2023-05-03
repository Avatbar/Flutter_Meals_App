import 'dart:io';

enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

extension ComplexStringifier on Complexity {
  String stringify() {
    switch (this) {
      case Complexity.simple:
        return 'Simple';
      case Complexity.challenging:
        return 'Challenging';
      case Complexity.hard:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }
}

extension ComplexParser on String {
  Complexity parseComplexity() {
    switch (this) {
      case 'Simple':
        return Complexity.simple;
      case 'Challenging':
        return Complexity.challenging;
      case 'Hard':
        return Complexity.hard;
      default:
        return Complexity.simple;
    }
  }
}

extension AffordablStringifier on Affordability {
  String stringify() {
    switch (this) {
      case Affordability.affordable:
        return 'Affordable';
      case Affordability.pricey:
        return 'Pricey';
      case Affordability.luxurious:
        return 'Luxurious';
      default:
        return 'Unknown';
    }
  }
}

extension AffordablParser on String {
  Affordability parseAffordability() {
    switch (this) {
      case 'Affordable':
        return Affordability.affordable;
      case 'Pricey':
        return Affordability.pricey;
      case 'Luxurious':
        return Affordability.luxurious;
      default:
        return Affordability.affordable;
    }
  }
}

class MealDatabase {
  MealDatabase({
    required this.id,
    required this.categories,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
    required this.creatorID,
  });

  final String id;
  bool approved = false;
  final List<String> categories;
  final String title;
  String imageURL = "";
  File? image;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;
  final String creatorID;

  void setImageURL(String url) {
    imageURL = url;
  }
  void setImage(File file) {
    image = file;
  }
}