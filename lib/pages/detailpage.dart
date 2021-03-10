import 'package:flutter/material.dart';
import 'package:flutter_food_app/api/food_api.dart';
import 'package:flutter_food_app/model/food_model.dart';
import 'package:flutter_food_app/notifire/food_notifire.dart';
import 'package:flutter_food_app/pages/splash.dart';
import 'package:flutter_food_app/screens/food_form.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final data;
  DetailPage(this.data);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
    }

    return Scaffold(
      // backgroundColor: Colors.amberAccent[200],
      body: Column(
        children: [
          SizedBox(
            height: 0,
          ),
          _customeAppBar(),
          Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: widget.data.image != null
                        ? widget.data.image
                        : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                    child: Image.network(
                      widget.data.image != null
                          ? widget.data.image
                          : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.data.category,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "\$${widget.data.price}",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.amberAccent[200],
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              )),
                          child: Text(
                            "S",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              )),
                          child: Text(
                            "M",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              )),
                          child: Text(
                            "L",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[400]),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCounter(),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            )),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Addtocart(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Icon(Icons.shopping_basket),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'button1',
            child: Icon(Icons.edit),
            backgroundColor: Colors.purpleAccent,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FoodForm(
                    isUpdate: true,
                  );
                }),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'button2',
            backgroundColor: Colors.red,
            child: Icon(Icons.delete),
            onPressed: () =>
                deleteFood(foodNotifier.currentFood, _onFoodDeleted),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.remove,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "1",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.amberAccent[200],
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customeAppBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      "${widget.data.name}",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("${widget.data.category}",
                        style:
                            TextStyle(fontSize: 20, color: Colors.grey[400])),
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
    );
  }
}
