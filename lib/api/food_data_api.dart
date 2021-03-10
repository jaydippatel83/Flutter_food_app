// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart'; 
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_food_app/api/food_notifire.dart';
// import 'package:flutter_food_app/model/food_model.dart';
// import 'package:path/path.dart' as path;
// import 'package:uuid/uuid.dart';

// getFoods(FoodNotifier foodNotifier) async {
//   QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('Foods').get();

//   List<FoodDataModel> _foodList = [];

//   snapshot.docs.forEach((document) {
//     FoodDataModel food = FoodDataModel.fromMap(document.data());
//     _foodList.add(food);
//   });

//   foodNotifier.foodList = _foodList;
// }

// uploadImage(FoodDataModel food, File localFile) async {
//   if (localFile != null) {
//     print("upload image");
//     var fileExtension = path.extension(localFile.path);
//     var uuid = Uuid().v4();
//     final storage = FirebaseStorage.instance
//         .ref()
//         .child('foods/images/$uuid$fileExtension');
//     await storage.putFile(localFile);

//     String url = await storage.getDownloadURL();
//     print("Url==============>$url");
//     uploadDataWithUrl(food, imgUrl: url);
//   } else {
//     print("skip");
//     uploadDataWithUrl(food);
//   }
// }

// uploadDataWithUrl(FoodDataModel food, {String imgUrl}) async {
//   CollectionReference snapshot = FirebaseFirestore.instance.collection('foods');
//   if (imgUrl != null) {
//     food.image = imgUrl;
//   }
//   DocumentReference docRef = await snapshot.add(food.toMap());
//   food.itemId = docRef.id;
//   await docRef.set(food.toMap(), SetOptions(merge: true));
// }

// uploadFoodAndImage(FoodDataModel food, bool isUpdating, File localFile,
//     Function foodUploaded) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final storage = FirebaseStorage.instance
//         .ref()
//         .child('foods/images/$uuid$fileExtension');
 
//     await storage
//         .putFile(localFile) 
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await storage.getDownloadURL();
//     print("download url: $url");
//     _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadFood(food, isUpdating, foodUploaded);
//   }
// }

// _uploadFood(FoodDataModel food, bool isUpdating, Function foodUploaded,
//     {String imageUrl}) async {
//   CollectionReference foodRef = FirebaseFirestore.instance.collection('Foods');

//   if (imageUrl != null) {
//     food.image = imageUrl;
//   } 
//   if (isUpdating) {
//     await foodRef.doc(food.itemId).update(food.toMap());
//     foodUploaded(food);
//   } else {
//     DocumentReference documentRef = await foodRef.add(food.toMap());
//     food.itemId = documentRef.id;
//     print('uploaded food successfully: ${food.toString()}'); 
//     await documentRef.set(food.toMap(), SetOptions(merge: true)); 
//     foodUploaded(food);
//   }
// }

// // deleteFood(Food food, Function foodDeleted) async {
// //   if (food.image != null) {
// //     StorageReference storageReference =
// //         await FirebaseStorage.instance.getReferenceFromUrl(food.image);

// //     print(storageReference.path);

// //     await storageReference.delete();

// //     print('image deleted');
// //   }

// //   await Firestore.instance.collection('Foods').document(food.id).delete();
// //   foodDeleted(food);
// // }
