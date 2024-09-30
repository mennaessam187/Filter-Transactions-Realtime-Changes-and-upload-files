import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secondproject_firebase/Token.dart';
import 'package:secondproject_firebase/auth/Login.dart';
import 'package:secondproject_firebase/auth/Register.dart';
import 'package:secondproject_firebase/screens/homescreen.dart';
import 'package:secondproject_firebase/screens/image_picker.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // No need for manual Firebase initialization if using google-services.json
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCYR9d0_AGX2F9glGE1HYBTyAT6KII5Kd8',
      appId: '1:5308976848:android:bfd22450392c65fe6c18d5',
      messagingSenderId: '5308976848',
      projectId: 'secondprojectoffirebase',
      storageBucket: 'secondprojectoffirebase.appspot.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ((FirebaseAuth.instance.currentUser != null) &&
              (FirebaseAuth.instance.currentUser!.emailVerified))
          ? MyToken()
          : Login(),
      routes: {
        "Login": (context) => Login(),
        "Register": (context) => Register(),
        "homepage": (context) => homepage()
      },
    );
  }
}
