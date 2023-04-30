class Person {
  final String _uid;
  final String _email;

  String get uid => _uid;
  String get email => _email;

  Person.fromSnapshot(Map<String, dynamic> snapshot)
      : _uid = snapshot['uid'],
        _email = snapshot['email'];
}
