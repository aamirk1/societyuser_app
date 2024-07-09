// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:number_to_character/number_to_character.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class LedgerReceiptDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LedgerReceiptDetailsPage({
    super.key,
    // required this.receiptData,
    required this.societyName,
    required this.name,
    required this.flatno,
    required this.receiptNo,
    required this.checkDate,
    required this.cheqNo,
    required this.amount,
    required this.bankName,
    required this.receiptDate,
  });

  // ignore: non_constant_identifier_names
  // Map<String, dynamic>? receiptData;
  String? societyName;
  String? name;
  String? flatno;
  String receiptNo;
  String checkDate;
  String cheqNo;
  String amount;
  String bankName;
  String receiptDate;

  @override
  State<LedgerReceiptDetailsPage> createState() =>
      _LedgerReceiptDetailsPageState();
}

class _LedgerReceiptDetailsPageState extends State<LedgerReceiptDetailsPage> {
  final SplashService _splashService = SplashService();

  bool isLoading = true;
  // List<dynamic> a = widget.name.toString().split('');
  // ignore: non_constant_identifier_names
  String? society_name;
  String? email;
  String? regNo;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String checkDate2 = '';

  // var converter = NumberToCharacterConverter('en');
  String words = '';

  // void numbertochar() {
  //   words = converter.getTextForNumber(amount);
  //   print(words);
  // }

  List<dynamic> receiptDetails = [];
  @override
  initState() {
    // fetchData(widget.receiptData!);
    // numbertochar();

    getSociety(widget.societyName ?? '').whenComplete(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Center(
            child: Text(
          'Receipt Details',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$society_name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("Registration Number: $regNo"),
                        Text(
                            "$society_name $landmark, $city, $state, $pincode"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "RECEIPT",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Receipt No: ${widget.receiptNo}',
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Receipt Date: ${widget.receiptDate}',
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Received with Thanks From: ${widget.name}"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Unit No.: ${widget.flatno}",
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Rs. ${widget.amount}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'By Cheque No.: ${widget.cheqNo}',
                                      style: TextStyle(color: textColor),
                                      textAlign: TextAlign.justify,
                                    ),
                                    Text(
                                      'Date On: ${widget.checkDate}',
                                      style: TextStyle(color: textColor),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Drawn on: ${widget.bankName} '),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getSociety(String societyname) async {
    // ignore: unused_local_variable
    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();

    DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('society')
        .doc(societyname)
        .get();
    Map<String, dynamic> societyData =
        societyQuerySnapshot.data() as Map<String, dynamic>;
    society_name = societyData['societyName'];
    email = societyData['email'];
    regNo = societyData['regNo'];
    landmark = societyData['landmark'];
    city = societyData['city'];
    state = societyData['state'];
    pincode = societyData['pincode'];
    setState(() {});
    isLoading = false;
  }
}
