import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_food_app/pages/food.dart';
import 'package:flutter_food_app/provider/food_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

// https://www.youtube.com/watch?v=t4QJoivDNqg

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String imageUrl;
  final picker = ImagePicker();
  String name;
  double price;
  String items;
  String size;
  final myController = TextEditingController();
  Food food;
  File imgFile;

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedFile != null) {
  //       imageUrl = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final itemController = TextEditingController();
  final sizeController = TextEditingController();
  
  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    itemController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final foodProvider = Provider.of<FoodProvider>(this.context, listen: false);
    if (food != null) {
      nameController.text = food.name;
      priceController.text = food.price.toString();
      itemController.text = food.item;
      sizeController.text = food.size;
      imageUrl = food.imgPath; 
      foodProvider.loadAll(food);
    } else {
      foodProvider.loadAll(null);
    } 

    super.initState();
  }

  Widget _showImage() {
    if (imgFile == null && imageUrl == null) {
      return Text("Image Placeholder");
    } else if (imgFile != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.file(
            imgFile,
            fit: BoxFit.cover,
            height: 100,
          ),
          TextButton(
            onPressed: () => _getLocalImg(),
            child: Text(
              "change image",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      );
      ;
    } else if (imageUrl != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 80,
          ),
          TextButton(
            onPressed: () => _getLocalImg(),
            child: Text("change image"),
          )
        ],
      );
    }
  }

  _getLocalImg() async { 
    File imageFile = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile.path));
    if (imageFile != null) {
      setState(() {
        imgFile = imageFile;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final snackbar = SnackBar(
      content: Text('Saved to Gallery'),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            )),
                        child: Icon(
                          Icons.arrow_back,
                          size: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Admin",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          )),
                      child: Icon(
                        Icons.shopping_basket,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlobalTextButtonWidget(
                      icon: Icon(Icons.add),
                      label: "Add",
                      bgColor: Colors.blue,
                      onPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Add Items'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _showImage(),
                                            // Align(
                                            //   alignment: Alignment.center,
                                            //   child: CircleAvatar(
                                            //     radius: 40,
                                            //     backgroundColor:
                                            //         Color(0xff476cfb),
                                            //     child: ClipOval(
                                            //       child: new SizedBox(
                                            //         child: (imageUrl != null)
                                            //             ? Image.file(
                                            //                 imageUrl,
                                            //                 fit: BoxFit.fill,
                                            //               )
                                            //             : Image.network(
                                            //                 "https://p.kindpng.com/picc/s/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png",
                                            //                 fit: BoxFit.fill,
                                            //               ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //       top: 0.0, left: 60),
                                        //   child: IconButton(
                                        //     alignment: Alignment.topRight,
                                        //     icon: Icon(
                                        //       Icons.camera_alt,
                                        //       size: 20.0,
                                        //     ),
                                        //     onPressed: () {
                                        //       // getImage();
                                        //     },
                                        //   ),
                                        // ),
                                        imgFile == null && imageUrl == null
                                            ? FlatButton(
                                                color: Colors.blue,
                                                onPressed: () => _getLocalImg(),
                                                child: Text(
                                                  "Add Image",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : Container(),
                                        TextFormField(
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "Name is required";
                                            }
                                            return null;
                                          },
                                          onChanged: (String value) =>
                                              foodProvider.changeName = value,
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                          ),
                                        ),
                                        // TextFormField(
                                        //   onChanged: (double value)=> foodProvider.changePrice = value,
                                        //   controller: priceController,
                                        //   inputFormatters: [
                                        //     FilteringTextInputFormatter
                                        //         .digitsOnly
                                        //   ],
                                        //   keyboardType: TextInputType.number,
                                        //   decoration: InputDecoration(
                                        //     labelText: 'Price',
                                        //   ),
                                        // ),
                                        TextFormField(
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "Items is required";
                                            }
                                            return null;
                                          },
                                          onChanged: (String value) =>
                                              foodProvider.changeItem = value,
                                          controller: itemController,
                                          decoration: InputDecoration(
                                            labelText: 'Items',
                                          ),
                                        ),
                                        TextFormField(
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "Size is required";
                                            }
                                            return null;
                                          },
                                          onChanged: (String value) =>
                                              foodProvider.changeSize = value,
                                          controller: sizeController,
                                          decoration: InputDecoration(
                                            labelText: 'Size',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GlobalTextButtonWidget(
                                        icon: Icon(Icons.cancel),
                                        label: "Cancel",
                                        bgColor: Colors.red,
                                        onPress: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      GlobalTextButtonWidget(
                                        icon: Icon(Icons.save),
                                        label: "Submit",
                                        bgColor: Colors.blue[400],
                                        onPress: () {
                                          foodProvider.uploadImage(
                                              food, imgFile);
                                          foodProvider.saveFood();
                                          Navigator.of(context).pop();
                                          // FirebaseFirestore.instance
                                          //     .collection('food')
                                          //     .add({
                                          //   'name': name,
                                          //   'price': myController,
                                          //   'item': items,
                                          //   'size': size
                                          // });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    GlobalTextButtonWidget(
                      icon: Icon(Icons.edit),
                      label: "Update",
                      bgColor: Colors.purple,
                      onPress: () {
                        print("Update");
                      },
                    ),
                    GlobalTextButtonWidget(
                      icon: Icon(Icons.delete),
                      label: "Delete",
                      bgColor: Colors.red,
                      onPress: () {
                        print("Delete");
                      },
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: StreamBuilder<List<Food>>(
                    stream: foodProvider.foods,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: Text(snapshot.data[index].name),
                            title: Text(snapshot.data[index].item),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlobalTextButtonWidget extends StatelessWidget {
  const GlobalTextButtonWidget({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.bgColor,
    @required this.onPress,
  }) : super(key: key);

  final Icon icon;
  final String label;
  final Color bgColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: icon,
        label: Text(label),
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: bgColor,
          onSurface: Colors.grey,
        ),
        onPressed: onPress);
  }
}
