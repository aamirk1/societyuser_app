import 'package:flutter/material.dart';

class ListOfServiceRequest extends StatefulWidget {
  const ListOfServiceRequest({super.key});

  @override
  State<ListOfServiceRequest> createState() => _ListOfServiceRequestState();
}

class _ListOfServiceRequestState extends State<ListOfServiceRequest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Service Request'),
      ),
    );
  }
}