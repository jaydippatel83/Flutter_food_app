import 'package:flutter/material.dart';

class Food {
  String itemId;
  String name;
  double price;
  String item;
  String imgPath;
  String size;

  Food(
      {@required this.itemId,
      this.name,
      this.price,
      this.item,
      this.size,
      this.imgPath});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      itemId: json['itemId'],
      name: json['name'],
      price: json['price'],
      item: json['item'],
      imgPath: json['imgPath'],
      size: json['size'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'price': price,
      'item': item,
      'imgPath': imgPath,
      'size': size,
    };
  }

  static List<Food> list = [
    Food(
      name: "Maxico",
      price: 120,
      item: "Mixed Pizza",
      imgPath: "1.png",
      size: "Small size 6 inch",
    ),
    Food(
      name: "Italian",
      price: 100,
      size: "Mediam size 9 inch",
      item: "Mixed pizza with cheese",
      imgPath: "2.png",
    ),
    Food(
      name: "Neapolitan pizza",
      price: 90,
      size: "Mediam size 10 inch",
      item: "Panzerotti",
      imgPath: "3.png",
    ),
    Food(
      name: "Margherita Pizza",
      price: 50,
      size: "Large size 12 inch",
      item: "Double Cheese",
      imgPath: "4.png",
    ),
    Food(
      name: "Sicilian Pizza",
      price: 20,
      size: "Large size 12 inch",
      item: "Deluxe Veggie",
      imgPath: "5.png",
    ),
  ];
}
