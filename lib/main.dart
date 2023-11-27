import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/screen/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBTEp34Y0CbkceRElxrh5Y9DNNnF7HwzoE",
          authDomain: "societymanagement-763f1.firebaseapp.com",
          projectId: "societymanagement-763f1",
          storageBucket: "societymanagement-763f1.appspot.com",
          messagingSenderId: "1077685961456",
          appId: "1:1077685961456:android:0386d8498d527683747835",
          measurementId: "G-3EHV4L3XZJ"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: ThemeData(
        //     inputDecorationTheme: InputDecorationTheme(
        //         border: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.white)))),
        title: 'Society User App',
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
        // loginScreen(),
        // HomeScreen(),
        );
  }
}
