import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/pages/home.dart';
import 'package:flutter_food_app/screens/loginscreen.dart';
import 'package:provider/provider.dart';

class AuthenticationWrappeer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>(); 
    if (firebaseUser != null) {
      return HomePage();
    }
    return Login();
  }
}
