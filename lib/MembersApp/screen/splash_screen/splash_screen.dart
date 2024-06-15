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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SplashService _splashService = SplashService();
  bool isLogin = false;
  String appName = "Society Manager";
  int currentIndex = 0;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  List<String> letters = [];

  void _splitAppName() {
    letters = appName.split('');
  }

  void _startAnimation() {
    for (int i = 0; i < letters.length; i++) {
      Future.delayed(Duration(milliseconds: 400 * i), () {
        setState(() {
          currentIndex = i;
        });
        _controller.forward();
      });
    }
  }

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
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
            .animate(_controller);
    _splitAppName();
    _startAnimation();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i <= currentIndex; i++)
                  if (i <= currentIndex)
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Text(
                              letters[i],
                              style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.2),
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
