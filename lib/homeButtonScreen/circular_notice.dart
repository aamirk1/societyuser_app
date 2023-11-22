import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class circular_notice extends StatelessWidget {
  const circular_notice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Circular Notice',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('This is Service Provider Page'),
      ])),
    );
  }
}