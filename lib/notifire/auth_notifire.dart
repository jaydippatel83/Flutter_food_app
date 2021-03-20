import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthNotifier with ChangeNotifier {
  User _user = FirebaseAuth.instance.currentUser;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
