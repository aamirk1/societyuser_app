import 'package:flutter/material.dart';

class ResidentManagement extends StatefulWidget {
  const ResidentManagement({super.key});

  @override
  State<ResidentManagement> createState() => _ResidentManagementState();
}

class _ResidentManagementState extends State<ResidentManagement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Resident Management'),
      ),
    );
  }
}
