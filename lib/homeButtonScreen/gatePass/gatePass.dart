// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GatePass extends StatelessWidget {
   GatePass({super.key,required this.flatno,required  this.societyName,required  this.username});
  String flatno;
  String societyName;
  String username;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Gate Pass'),
      ),
    );
  }
}
