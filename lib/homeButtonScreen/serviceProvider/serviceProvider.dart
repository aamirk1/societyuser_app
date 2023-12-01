// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ServiceProvider extends StatefulWidget {
  const ServiceProvider({super.key});

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
