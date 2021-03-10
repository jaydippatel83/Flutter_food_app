import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter_food_app/model/food_model.dart';

class AuthNotifier with ChangeNotifier {
  List<UserData> _userList = [];
  UserData _currentUser;

  UnmodifiableListView<UserData> get userList =>
      UnmodifiableListView(_userList);

  UserData get currentuser => _currentUser;

  set userList(List<UserData> userList) {
    _userList = userList;
    notifyListeners();
  }
}
