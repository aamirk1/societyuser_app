import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  Future<bool> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }

  Future<String> getPhoneNum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNum = prefs.getString('phoneNum') ?? '';

    return phoneNum;
  }

  void removeLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.remove('isLogin');
  }
  
}
