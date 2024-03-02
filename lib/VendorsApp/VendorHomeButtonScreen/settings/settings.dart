// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen(
      {super.key,
      required this.flatno,
      required this.societyName,
      required this.username});
  String flatno;
  String societyName;
  String username;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Resident Management'),
      ),
    );
  }
}
