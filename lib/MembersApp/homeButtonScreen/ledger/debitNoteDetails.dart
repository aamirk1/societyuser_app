// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:number_to_character/number_to_character.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class DebitNoteDetails extends StatefulWidget {
  // ignore: non_constant_identifier_names
  DebitNoteDetails(
      {super.key,
      // ignore: non_constant_identifier_names
      // required this.noteData,
      required this.societyName,
      required this.name,
      required this.flatno,
      required this.debitNoteNumber,
      required this.date,
      required this.amount,
      required this.particulars,
      required this.month});

  // ignore: non_constant_identifier_names
  // Map<String, dynamic>? noteData;
  String societyName;
  String name;
  String flatno;

  String? debitNoteNumber;
  String date;
  String amount;
  String particulars;
  String month;

  @override
  State<DebitNoteDetails> createState() => _DebitNoteDetailsState();
}

class _DebitNoteDetailsState extends State<DebitNoteDetails> {
  final SplashService _splashService = SplashService();

  bool isLoading = true;
  // ignore: non_constant_identifier_names
  String? society_name;
  String? email;
  String? regNo;
  String? landmark;
  String? city;
  String? state;
  String? pincode;

  List<String> colums = [
    'Sr. No.',
    'Particulars of \n Changes',
    'Amount',
  ];
  List<dynamic> billDetails = [];

  // var converter = NumberToCharacterConverter('en');
  String words = '';
  String phoneNum = '';
  // void numbertochar() {
  //   words = converter.getTextForNumber(billAmount!);
  // }

  @override
  initState() {
    // fetchData(widget.);
    getSociety(widget.societyName).whenComplete(() {});
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
            'Debit Note Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.99,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$society_name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text("Registration Number: $regNo"),
                        Text(
                            "$society_name $landmark, $city, $state, $pincode"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "DEBIT NOTE",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Flat No.: ${widget.flatno}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Name: ${widget.name}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Note No.: ${widget.debitNoteNumber == '' ? 'N/A' : widget.debitNoteNumber}",
                                      style: TextStyle(
                                          color: textColor, fontSize: 12),
                                    ),
                                    Text(
                                      "Date: ${widget.date == '' ? 'N/A' : widget.date}",
                                      style: TextStyle(
                                          color: textColor, fontSize: 12),
                                    ),
                                  ])
                            ]),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  dividerThickness: 0,
                                  columnSpacing: 60,
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      colums[0],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      colums[1],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      colums[2],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                  rows: List.generate(1, (index) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Text((index + 1).toString()),
                                      ),
                                      DataCell(
                                        Text(widget.particulars),
                                      ),
                                      DataCell(
                                        Text(widget.amount),
                                      )
                                    ]);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Row(children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Total",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(":"),
                                            // Text(":"),
                                            // Text(":"),
                                          ],
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text("${widget.amount}",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                        Divider(
                                          color: textColor,
                                          thickness: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.99,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    'Being add Rs. ${widget.amount}/- for ${widget.particulars}. For the month of ${widget.month} as per manager instruction date - ${widget.date}',
                                style:
                                    TextStyle(fontSize: 10, color: textColor),
                              ),
                            ]),
                          ),
                        )
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
