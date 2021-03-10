import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/screens/loginscreen.dart';
import 'package:flutter_food_app/screens/profile.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  final bool login;
  final Function press;
  const Signup({
    this.login = false,
    this.press,
  });

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email, password,username;
  final auth = FirebaseAuth.instance;  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "images/signup_top.png",
                  width: size.width * 0.15,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  "images/main_bottom.png",
                  width: size.width * 0.25,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SIGNUP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Image.asset(
                    "images/s.jpg",
                    height: size.height * 0.20,
                  ),
                   Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.amberAccent[100],
                        borderRadius: BorderRadius.circular(29)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintText: "User Name",
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.amberAccent[100],
                        borderRadius: BorderRadius.circular(29)),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          hintText: "Email",
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.amberAccent[100],
                        borderRadius: BorderRadius.circular(29)),
                    child: TextField(
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintText: "Password",
                          suffixIcon: Icon(
                            Icons.visibility,
                            color: Colors.black,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                        color: Colors.amberAccent[400],
                        child: TextButton(
                          onPressed: () {
                            context.read<FirebaseAuthService>().signUp(
                                  email: email.trim(),
                                  password: password.trim(),
                                  username: username
                                );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Login(),
                              ),
                            );
                            // auth.createUserWithEmailAndPassword(
                            //     email: email, password: password);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) {
                            //     return Profile();
                            //   }),
                            // );
                          },
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.login
                            ? "Don't have an account ? "
                            : "Already have an account ? ",
                      ),
                      // SizedBox(
                      //   height: size.height * 0.1,
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          widget.login ? "Sign Up" : "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.amberAccent),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    width: size.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.amberAccent,
                            height: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "OR",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.amberAccent,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.amberAccent,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "images/t.png",
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.amberAccent,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "images/f.png",
                          width: 20,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.amberAccent,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "images/g.png",
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
