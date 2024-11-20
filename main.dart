import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/password.dart';
import 'package:flutter_project/register.dart';
import 'Login.dart';
import 'home.dart';
import 'favourite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that binding is initialized
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(MyApp()); // Run the main app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => MyRegister(),
        'password': (context) => SetPassword(),
        'home': (context) => HomePage(),
        'favourite': (context) => FavouritePage(),
      },
    );
  }
}
