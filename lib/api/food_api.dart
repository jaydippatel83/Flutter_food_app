import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_food_app/model/food_model.dart';
import 'package:flutter_food_app/notifire/auth_notifire.dart';
import 'package:flutter_food_app/notifire/food_notifire.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

getUserData(AuthNotifier authNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Users').get();

  List<UserData> _userList = [];

  snapshot.docs.forEach((document) {
    UserData user = UserData.fromMap(document.data());
    _userList.add(user);
  });

  authNotifier.userList = _userList;
}

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

    await foodRef.doc(food.id).update(food.toMap());

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
