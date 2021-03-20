import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/api/food_api.dart';
import 'package:flutter_food_app/firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/model/auth_model.dart';
import 'package:flutter_food_app/notifire/auth_notifire.dart';
import 'package:flutter_food_app/pages/home.dart';
import 'package:flutter_food_app/screens/signup.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  final bool login;
  final Function press;
  const Login({
    this.login = true,
    this.press,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  final auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pwdController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  UserData _userData = UserData();

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_userData, authNotifier);
    } else {
      signup(_userData, authNotifier);
    }
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          hintText: "User Name",
          border: InputBorder.none),
      style: TextStyle(fontSize: 20, color: Colors.black),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Display Name is required';
        }

        if (value.length < 5 || value.length > 12) {
          return 'Display Name must be betweem 5 and 12 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _userData.displayName = value;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Colors.black,
          ),
          hintText: "Enter Email",
          border: InputBorder.none),
      style: TextStyle(fontSize: 20, color: Colors.black),
      keyboardType: TextInputType.emailAddress, 
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _userData.email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.black,
          ),
          hintText: "Password",
          border: InputBorder.none),
      style: TextStyle(fontSize: 20, color: Colors.black),
      obscureText: true,
      controller: _pwdController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }

        if (value.length < 5 || value.length > 20) {
          return 'Password must be betweem 5 and 20 characters';
        }

        return null;
      },
      onSaved: (String value) {
        _userData.password = value;
      },
    );
  }

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
                  "images/main_top.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "images/login_bottom.png",
                  width: size.width * 0.4,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Image.asset(
                      "images/l.jpg",
                      height: size.height * 0.35,
                      width: size.width * 0.7,
                    ),
                    _authMode == AuthMode.Signup
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.amberAccent[100],
                                borderRadius: BorderRadius.circular(29)),
                            child: _buildDisplayNameField(),
                          )
                        : Container(),
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
                      child: _buildEmailField(),
                      // child: TextFormField(
                      //   validator: (String value) {
                      //     if (value.isEmpty) {
                      //       return "Email is required";
                      //     }
                      //     return null;
                      //   },
                      //   keyboardType: TextInputType.emailAddress,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       email = value.trim();
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //       icon: Icon(
                      //         Icons.person,
                      //         color: Colors.black,
                      //       ),
                      //       hintText: "Enter Email",
                      //       border: InputBorder.none),
                      // ),
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
                      child: _buildPasswordField(),
                      // child: TextFormField(
                      //   validator: (String value) {
                      //     if (value.isEmpty) {
                      //       return "Password is required";
                      //     }
                      //     if (value.length < 6) {
                      //       return "Password must be minimum 6 charecters";
                      //     }

                      //     return null;
                      //   },
                      //   obscureText: true,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       password = value.trim();
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //       icon: Icon(
                      //         Icons.lock,
                      //         color: Colors.black,
                      //       ),
                      //       hintText: "Password",
                      //       suffixIcon: Icon(
                      //         Icons.visibility,
                      //         color: Colors.black,
                      //       ),
                      //       border: InputBorder.none),
                      // ),
                    ),
                    SizedBox(
                      height: 10,
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
                            onPressed: _submitForm,
                            // context.read<FirebaseAuthService>().signIn(
                            //       email: email.trim(),
                            //       password: password.trim(),
                            //     );
                            // auth.signInWithEmailAndPassword(
                            //     email: email, password: password);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (contaxt) => HomePage()));

                            child: Text(
                              '${_authMode == AuthMode.Login ? 'Login' : 'Signup'}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.login
                              ? "Don't have an account ? "
                              : "Already have an account ? ",
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (_) => Signup(),
                            //   ),
                            // );
                            setState(() {
                              _authMode = _authMode == AuthMode.Login
                                  ? AuthMode.Signup
                                  : AuthMode.Login;
                            });
                          },
                          child: Text(
                            "${_authMode == AuthMode.Login ? 'Signup' : 'Login'}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.amberAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
