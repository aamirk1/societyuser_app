// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';

class ViewResponse extends StatefulWidget {
  const ViewResponse({super.key});

  @override
  State<ViewResponse> createState() => _ViewResponseState();
}

class _ViewResponseState extends State<ViewResponse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'View Response',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('View Response'),
      ),
    );
  }
}
