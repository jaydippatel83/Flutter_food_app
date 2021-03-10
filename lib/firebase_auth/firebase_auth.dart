import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/api/auth_db_service.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth;
  FirebaseAuthService(this.firebaseAuth);

  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Sign In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password,String username}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
     await DatabaseService(uid:  firebaseAuth.currentUser.uid).postUserData(email, username);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
