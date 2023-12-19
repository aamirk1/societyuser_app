import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: must_be_immutable
class LedgerReceiptDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LedgerReceiptDetailsPage(
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
  State<LedgerReceiptDetailsPage> createState() =>
      _LedgerReceiptDetailsPageState();
}

class _LedgerReceiptDetailsPageState extends State<LedgerReceiptDetailsPage> {
  final SplashService _splashService = SplashService();

  bool isLoading = true;
  // List<dynamic> a = widget.name.toString().split('');
  String? society_name;
  String? email;
  String? regNo;
  String? landmark;
  String? city;
  String? state;
  String? pincode;

  String? checkDate;
  String? cheqNo;
  int amount = 0;
  String? bankName;
  String? receiptDate;
  String? repairFund;
  String? othercharges;
  String? sinkingfund;
  String? nonOccupancyChg;
  String? interest;
  String? towerBenefit;
  var converter = NumberToCharacterConverter('en');
  String words = '';

  void numbertochar() {
    words = converter.getTextForNumber(amount);
    print(words);
  }

  List<dynamic> receiptDetails = [];
  @override
  initState() {
    fetchData(widget.ReceiptData!);
    numbertochar();

    getSociety(widget.societyName ?? '').whenComplete(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Center(child: Text('Receipt Details')),
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
                              'Receipt No: $cheqNo',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Date: $receiptDate',
                              style: const TextStyle(
                                  color: Colors.black,
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
                              "Rs. $amount",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("(Rupees $words only) "),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'By Cheque No.: $cheqNo',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                'Date On: $checkDate',
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Drawn on: $bankName '),
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

  Future<void> fetchData(Map<String, dynamic> data) async {
    checkDate = data['ChqDate'] ?? "N/A";
    cheqNo = data['ChqNo'] ?? "N/A";
    amount = int.parse(data['Amount'] ?? 0);
    bankName = data['Bank Name'] ?? "N/A";
    receiptDate = data['Receipt Date'] ?? "N/A";

    receiptDetails.add(checkDate);
    receiptDetails.add(cheqNo);
    receiptDetails.add(amount);
    receiptDetails.add(bankName);
    receiptDetails.add(receiptDate);
    print(receiptDetails);
    setState(() {});
    isLoading = false;
  }
}
