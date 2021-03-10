import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/notifire/food_notifire.dart';
import 'package:flutter_food_app/provider/food_provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart'; 
import 'firebase_auth/auth_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.crash();

  FirebaseCrashlytics.instance.setCustomKey('str_key', 'hello');
  FirebaseCrashlytics.instance.log("Higgs-Boson detected! Bailing out");
  FirebaseCrashlytics.instance.setUserIdentifier("12345");
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  runApp(MultiProvider(
    providers: [
      Provider<FirebaseAuthService>(
        create: (_) => FirebaseAuthService(FirebaseAuth.instance),
      ),
      StreamProvider(
        create: (context) =>
            context.read<FirebaseAuthService>().authStateChanges,
        initialData: null,
      )
    ],
    child: ChangeNotifierProvider(
      create: (context) => FoodNotifier(),
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: new MyApp(),
      ),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirebaseAuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: SplashScreen(
          seconds: 14,
          navigateAfterSeconds: new AuthenticationWrappeer(),
          title: new Text(
            'Welcome Fast-Food App',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
          image: new Image.asset('images/splash.png'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(
              color: Colors.amberAccent[200], fontWeight: FontWeight.bold),
          photoSize: 100.0,
          loaderColor: Colors.amberAccent[200]),
    );
  }
}
