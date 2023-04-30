import 'package:meals_app/models/person.dart';

class Admin extends Person {
  late List<String> _mealsForApproval;
  final bool isAdmin = true;

  List<String> get mealsForApproval => _mealsForApproval;

  Admin.fromSnapshot(Map<String, dynamic> snapshot) : super.fromSnapshot(snapshot) {
    _mealsForApproval = snapshot['mealsForApproval'];
  }
}