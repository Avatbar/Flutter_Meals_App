import 'package:meals_app/models/person.dart';

class User extends Person {
  late List<String> _userFavorites;
  final bool isAdmin = false;
  late bool _glutenFree;
  late bool _lactoseFree;
  late bool _vegetarian;
  late bool _vegan;

  List<String> get userFavorites => _userFavorites;
  
  User.fromSnapshot(Map<String, dynamic> snapshot) : super.fromSnapshot(snapshot) {
    _userFavorites = snapshot['userFavorites'];
    _glutenFree = snapshot['glutenFree'];
    _lactoseFree = snapshot['lactoseFree'];
    _vegetarian = snapshot['vegetarian'];
    _vegan = snapshot['vegan'];
  }
}