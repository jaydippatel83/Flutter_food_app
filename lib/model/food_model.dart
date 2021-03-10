import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String email;
  String username;
  UserData();
  UserData.fromMap(Map<String, dynamic> user) {
    email = user['email'];
    username = user['username'];
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
    };
  }
}

class Food {
  String id;
  String name;
  String price;
  String category;
  String image;
  List subIngredients = [];
  Timestamp createdAt;
  Timestamp updatedAt;

  Food();

  Food.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    price = data['price'];
    category = data['category'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'image': image,
      'subIngredients': subIngredients,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
