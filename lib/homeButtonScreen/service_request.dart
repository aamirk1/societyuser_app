import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class serviceRequest extends StatelessWidget {
  const serviceRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Service Request',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('This is Service Request Page'),
      ])),
    );
  }
}
