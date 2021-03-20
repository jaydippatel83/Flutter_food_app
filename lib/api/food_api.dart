import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/model/auth_model.dart';
import 'package:flutter_food_app/model/food_model.dart';
import 'package:flutter_food_app/notifire/auth_notifire.dart';
import 'package:flutter_food_app/notifire/food_notifire.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

login(UserData user, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    User firebaeUser = authResult.user;

    if (firebaeUser != null) {
      print("Log In: $user");
      authNotifier.setUser(firebaeUser);
    }
  }
}

signup(UserData user, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
     FirebaseAuth.instance.currentUser.updateProfile(displayName:user.displayName); 

     User firebaseUser = authResult.user;

    if (firebaseUser != null) {
//     await FirebaseAuth.instance.currentUser.updateProfile(displayName: authResult.user.displayName);

       await firebaseUser.updateProfile(displayName:user.displayName);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      User currentUser = await FirebaseAuth.instance.currentUser;
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

// getUserData(AuthNotifier authNotifier) async {
//   QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('Users').get();

//   List<UserData> _userList = [];

//   snapshot.docs.forEach((document) {
//     UserData user = UserData.fromMap(document.data());
//     _userList.add(user);
//   });

//   authNotifier.userList = _userList;
// }

getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Foods')
      .orderBy("createdAt", descending: true)
      .get();

  List<Food> _foodList = [];

  snapshot.docs.forEach((document) {
    Food food = Food.fromMap(document.data());
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
}

uploadFoodAndImage(
    Food food, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('foods/images/$uuid$fileExtension');

    await ref.putFile(localFile).catchError((onError) {
      print(onError);
      return false;
    });

    String url = await ref.getDownloadURL();
    print("download url: $url");
    _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFood(food, isUpdating, foodUploaded);
  }
}

_uploadFood(Food food, bool isUpdating, Function foodUploaded,
    {String imageUrl}) async {
  CollectionReference foodRef = FirebaseFirestore.instance.collection('Foods');

  if (imageUrl != null) {
    food.image = imageUrl;
  }

  if (isUpdating) {
    food.updatedAt = Timestamp.now();
    await foodRef.doc(food.id).update(food.toMap()).catchError((e) {
      print(e);
    });

    foodUploaded(food);
    print('updated food with id: ${food.id}');
  } else {
    food.createdAt = Timestamp.now();
    DocumentReference documentRef = await foodRef.add(food.toMap());
    food.id = documentRef.id;
    print('uploaded food successfully: ${food.toString()}');
    await documentRef.set(food.toMap(), SetOptions(merge: true));
    foodUploaded(food);
  }
}

deleteFood(Food food, Function foodDeleted) async {
  if (food.image != null) {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.refFromURL(food.image);
    print(ref.fullPath);
    await ref.delete();
    print('image deleted');
  }

  await FirebaseFirestore.instance.collection('Foods').doc(food.id).delete();
  foodDeleted(food);
}
