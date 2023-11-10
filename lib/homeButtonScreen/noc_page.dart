import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class nocPage extends StatelessWidget {
  const nocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'NOC ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('This is NOC Page'),
      ])),
    );
  }
}
