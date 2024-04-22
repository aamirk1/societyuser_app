import 'dart:async';

import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/screen/HomeScreen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashService _splashService = SplashService();
  bool isLogin = false;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 3000), () async {
      isLogin = await _splashService.checkLoginStatus(context);
      if (isLogin) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const loginScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'SIMS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
