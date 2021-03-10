import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/firebase_auth/firestore_service.dart';
import 'package:flutter_food_app/pages/food.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class FoodProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  String _name;
  double _price;
  String _item;
  String _imgPath;
  String _itemId;
  String _size;
  var uuid = Uuid();

  String get name => _name;
  double get price => _price;
  String get item => _item;
  String get imgePath => _imgPath;
  String get size => _size;
  Stream<List<Food>> get foods => firestoreService.getFoodData();

  set changeName(String name) {
    _name = name;
    notifyListeners();
  }

  set changePrice(double price) {
    _price = price;
    notifyListeners();
  }

  set changeItem(String item) {
    _item = item;
    notifyListeners();
  }

  set changeImg(String imgPath) {
    _imgPath = imgPath;
    notifyListeners();
  }

  set changeSize(String size) {
    _size = size;
    notifyListeners();
  }

  loadAll(Food food) {
    if (food != null) {
      _name = food.name;
      _price = food.price;
      _item = food.item;
      _imgPath = food.imgPath;
      _itemId = food.itemId;
      _size = food.size;
    } else {
      _name = null;
      _price = null;
      _item = null;
      _imgPath = null;
      _itemId = null;
      _size = null;
    }
  }

  saveFood() {
    if (_itemId == null) {
      var newFood = Food(
          name: _name,
          price: _price,
          item: _item,
          imgPath: _imgPath,
          itemId: uuid.v1(),
          size: _size);
      firestoreService.setFoodData(newFood);
    } else {
      var updateFood = Food(
          name: _name,
          price: _price,
          item: _item,
          imgPath: _imgPath,
          itemId: _itemId,
          size: _size);
      firestoreService.setFoodData(updateFood);
    }
  }

  removeFood(String itemId) {
    firestoreService.removeFoodData(itemId);
  }

  uploadImage(Food food, File localFile) async {
    if (localFile != null) {
      print("upload image");
      var fileExtension = path.extension(localFile.path);
      var uuid = Uuid().v4();
      final storage = FirebaseStorage.instance
          .ref()
          .child('foods/images/$uuid$fileExtension');
      await storage.putFile(localFile);

      String url = await storage.getDownloadURL();
      uploadDataWithUrl(food,imgUrl: url);

    }else{
      print("skip");
       uploadDataWithUrl(food);

    }
  }

  uploadDataWithUrl(Food food,{String imgUrl}) async{
    CollectionReference snapshot= FirebaseFirestore.instance.collection('foods');
    if(imgUrl != null){
      food.imgPath=imgUrl;
    }
    DocumentReference docRef=await snapshot.add(food.toMap());
    food.itemId=docRef.id;
    await docRef.set(food.toMap(),);
  }
}
