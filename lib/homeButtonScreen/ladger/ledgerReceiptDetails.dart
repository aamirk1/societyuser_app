import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: must_be_immutable
class LadgerReceiptDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LadgerReceiptDetailsPage(
      {super.key,
      required this.ReceiptData,
      required this.societyName,
      required this.name,
      required this.flatno});

  // ignore: non_constant_identifier_names
  Map<String, dynamic>? ReceiptData;
  String? societyName;
  String? name;
  String? flatno;

  @override
  State<LadgerReceiptDetailsPage> createState() =>
      _LadgerReceiptDetailsPageState();
}

class _LadgerReceiptDetailsPageState extends State<LadgerReceiptDetailsPage> {
  @override
  initState() {
    print('Receipt Data......  ${widget.ReceiptData}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBgColor,
          title: const Center(child: Text('Receipt Details')),
        ),
        body: const Center(
          child: Text('Receipt Details'),
        ));
  }
}
