import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_food_app/api/food_api.dart';
import 'package:flutter_food_app/model/food_model.dart';
import 'package:flutter_food_app/notifire/food_notifire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FoodForm extends StatefulWidget {
  final bool isUpdate;
  FoodForm({@required this.isUpdate});
  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List _subingredients = [];
  Food _currentFood;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientsController = new TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = Food();
    }
    _subingredients.addAll(_currentFood.subIngredients);
    _imageUrl = _currentFood.image;
  }

  Widget _showImage() {
    if (_imageUrl == null && _imageFile == null) {
      return Text("Image Placeholder");
    } else if (_imageFile != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            onPressed: () => _getLocalImage(),
            child: Text(
              "Change Image",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      );
    } else if (_imageUrl != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            onPressed: () => _getLocalImage(),
            child: Text(
              "Change Image",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      );
    }
    return null;
  } 
  _getLocalImage() async {
    final imageFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);
    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      initialValue: _currentFood.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
        if (value.length < 5 || value.length > 20) {
          return "Name is more then 5 and less then 20 charecters";
        }
        return null;
      },
      onSaved: (String value) {
        _currentFood.name = value;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      initialValue: _currentFood.price,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'price is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentFood.price = value;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Category"),
      initialValue: _currentFood.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentFood.category = value;
      },
    );
  }

  Widget _buildSubField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: subingredientsController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Subingredients",
        ),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context,listen: false);
    foodNotifier.addFood(food);
    Navigator.pop(context);
  }

  _addSubingredients(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subingredients.add(text);
      });
      subingredientsController.clear();
    } 
  }

  _saveFood(context) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return;
    }
    form.save(); 
    _currentFood.subIngredients=_subingredients; 
    uploadFoodAndImage(_currentFood,widget.isUpdate,_imageFile,_onFoodUploaded); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Food Form"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: [
              _showImage(),
              SizedBox(
                height: 16,
              ),
              Text(
                widget.isUpdate ? "Edit Food" : "Create Food",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 16,
              ),
              _imageFile == null && _imageUrl == null
                  ? ButtonTheme(
                      child: RaisedButton(
                        onPressed: () => _getLocalImage(),
                        child: Text(
                          "Add Image",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              _buildNameField(),
              _buildPriceField(),
              _buildCategoryField(),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSubField(),
                  ButtonTheme(
                    child: RaisedButton(
                      onPressed: () =>
                          _addSubingredients(subingredientsController.text),
                      child: Text(
                        "Add ",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              GridView.count(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8),
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                children: _subingredients
                    .map(
                      (ingredient) => Card(
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            ingredient,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           FocusScope.of(context).requestFocus(new FocusNode());
           _saveFood(context);
        } ,
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
