import 'package:meals_app/models/person.dart';

class User extends Person {
  late List<String> _userMeals;
  late List<String> _userFavorites;
  final bool isAdmin = false;

  List<String> get userMeals => _userMeals;
  List<String> get userFavorites => _userFavorites;
  
  User.fromSnapshot(Map<String, dynamic> snapshot) : super.fromSnapshot(snapshot) {
    _userMeals = snapshot['userMeals'];
    _userFavorites = snapshot['userFavorites'];
  }
}