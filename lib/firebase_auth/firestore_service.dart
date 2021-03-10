import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_food_app/pages/food.dart';

class FirestoreService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<Food>> getFoodData() {
    return db.collection('foods').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
  }

  Future<void> setFoodData(Food food) {
    var options = SetOptions(merge: true);
    return db.collection('foods').doc(food.itemId).set(food.toMap(), options);
  }

  Future<void> removeFoodData(String itemId) {
    return db.collection('foods').doc(itemId).delete();
  }
}
