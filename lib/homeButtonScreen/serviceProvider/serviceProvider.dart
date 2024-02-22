// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ServiceProvider extends StatefulWidget {
   ServiceProvider({super.key,required this.flatno,required  this.societyName,required  this.username});
  String flatno;
  String societyName;
  String username;

  @override
  State<ServiceProvider> createState() => _ServiceProviderState();
}

class _ServiceProviderState extends State<ServiceProvider> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Service Provider'),
      ),
    );
  }
}
