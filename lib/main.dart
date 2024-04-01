import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/provider/AllComplaintProvider.dart';
import 'package:societyuser_app/MembersApp/provider/AllGatePassProvider.dart';
import 'package:societyuser_app/MembersApp/provider/AllNocProvider.dart';
import 'package:societyuser_app/MembersApp/provider/AllNoticeProvider.dart';
import 'package:societyuser_app/MembersApp/provider/AllSendComplaintsProvider.dart';
import 'package:societyuser_app/MembersApp/provider/emplist_builder_provider.dart';
import 'package:societyuser_app/MembersApp/provider/list_builder_provider.dart';

import 'MembersApp/screen/splash_screen/splash_screen.dart';

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

  await FlutterDownloader.initialize(
      debug: true // Set this to false in production
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AllNoticeProvider()),
        ChangeNotifierProvider(create: (_) => AllNocProvider()),
        ChangeNotifierProvider(create: (_) => AllComplaintProvider()),
        ChangeNotifierProvider(create: (_) => AllGatePassProvider()),
        ChangeNotifierProvider(create: (_) => ListBuilderProvider()),
        ChangeNotifierProvider(create: (_) => EmpListBuilderProvider()),
        ChangeNotifierProvider(create: (_) => AllSendComplaintsProvider()),
      ],
      child: MaterialApp(
          title: 'Society User App',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(error: Colors.white)),
          debugShowCheckedModeBanner: false,
          home: //const signUp(),
              SplashScreen()),
    );
  }
}
