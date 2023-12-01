// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';

class ViewComplaintsResponse extends StatefulWidget {
  const ViewComplaintsResponse({super.key});

  @override
  State<ViewComplaintsResponse> createState() => _ViewComplaintsResponseState();
}

class _ViewComplaintsResponseState extends State<ViewComplaintsResponse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'View Complaint Response',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('View Complaint Response'),
      ),
    );
  }
}
