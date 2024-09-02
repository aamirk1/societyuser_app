// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:number_to_character/number_to_character.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class LedgerBillDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LedgerBillDetailsPage({
    super.key,
    required this.societyName,
    required this.name,
    required this.flatno,
    required this.billDate,
    required this.billNo,
    required this.billAmount,
    required this.dueDate,
    required this.interest,
    this.legalNoticeCharges,
    this.maintenanceCharges,
    this.mhadaLeaseRent,
    this.nonOccupancyChg,
    this.parkingCharges,
    this.repairFund,
    this.sinkingFund,
    this.towerBenefit,
    this.municipalTax,
    this.othercharges,
  });

  String societyName;
  String name;
  String flatno;
  String billDate;
  String billNo;
  String billAmount;
  String dueDate;
  String interest;
  String? legalNoticeCharges;
  String? maintenanceCharges;
  String? mhadaLeaseRent;
  String? nonOccupancyChg;
  String? parkingCharges;
  String? repairFund;
  String? sinkingFund;
  String? towerBenefit;
  String? municipalTax;
  String? othercharges;

  @override
  State<LedgerBillDetailsPage> createState() => _LedgerBillDetailsPageState();
}

class _LedgerBillDetailsPageState extends State<LedgerBillDetailsPage> {
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

  dynamic totalDues = 0.0;
  List<String> colums = [
    'Sr. No.',
    'Particulars of \n Changes',
    'Amount',
  ];
  List<String> particulars = [
    'Maintenance Charges',
    'Municipal Tax',
    'Legal Notice Charges',
    'Parking Charges',
    'Mhada Lease Rent',
    'repair Fund',
    'Other Charges',
    'Sinking Fund',
    'Non Occupancy Chg',
    'Interest',
    'Tower Benefit',
  ];

  List<String> valuesbill = [];
  // var converter = NumberToCharacterConverter('en');
  String words = '';
  String phoneNum = '';
  // void numbertochar() {
  //   words = converter.getTextForNumber(widget.billAmount as int);
  // }

  @override
  initState() {
    valuesbill.add(widget.maintenanceCharges ?? '0');
    valuesbill.add(widget.municipalTax ?? '0');
    valuesbill.add(widget.legalNoticeCharges ?? '0');
    valuesbill.add(widget.parkingCharges ?? '0');
    valuesbill.add(widget.mhadaLeaseRent ?? '0');
    valuesbill.add(widget.repairFund ?? '0');
    valuesbill.add(widget.othercharges ?? '0');
    valuesbill.add(widget.sinkingFund ?? '0');
    valuesbill.add(widget.nonOccupancyChg ?? '0');
    valuesbill.add(widget.interest);
    valuesbill.add(widget.towerBenefit ?? '0');
    totalDues = double.parse(widget.billAmount) +
        double.parse(widget.interest == '' ? '0' : widget.interest);
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
          'Bill Details',
          style: TextStyle(color: Colors.white),
        )),
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
                          "MAINTENANCE BILL",
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
                                          0.45,
                                      child: Text(
                                        "Name: ${widget.name}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Flat No.: ${widget.flatno}"),
                                    Text(
                                      "Bill No.: ${widget.billNo == '' ? 'N/A' : widget.billNo}",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Bill Date: ${widget.billDate == '' ? 'N/A' : widget.billDate}",
                                      style: TextStyle(
                                          color: textColor, fontSize: 12),
                                    ),
                                    Text(
                                      "Due Date: ${widget.dueDate == '' ? 'N/A' : widget.dueDate}",
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
                              height: MediaQuery.of(context).size.height * 0.32,
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  dividerThickness: 0,
                                  columnSpacing: 20,
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
                                  rows: List.generate(11, (index) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Text((index + 1).toString()),
                                      ),
                                      DataCell(
                                        Text(particulars[index]),
                                      ),
                                      DataCell(
                                        Text(valuesbill[index]),
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
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: Row(children: [
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  "Rupees $words Only",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              thickness: 1,
                              color: textColor,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
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
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              "Previous Dues",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              "Intrest On Dues",
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(":"),
                                            Text(":"),
                                            Text(":"),
                                          ],
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(widget.billAmount,
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                              Text(widget.billAmount,
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                              Text(
                                                  "${widget.interest == '' ? 0 : widget.interest}",
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                            ]),
                                        Divider(
                                          color: textColor,
                                          thickness: 1,
                                        ),
                                      ],
                                    ),
                                    Divider(color: textColor, thickness: 1),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total Dues Amount: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${totalDues == '' ? 0 : totalDues}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ])
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
                          // height: MediaQuery.of(context).size.height * 0.1,
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Please pay your dues on or before Due Date. Otherwise Simple interest @21%p.a. will be charged on Arrears. Please Pay by cross cheques or via NEFT only in favouring ',
                                  style:
                                      TextStyle(fontSize: 10, color: textColor),
                                ),
                                TextSpan(
                                  text: '$society_name',
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      ' and mention your flat number. If you have any descrepancy in the bill please contact society office.',
                                  style:
                                      TextStyle(fontSize: 10, color: textColor),
                                )
                              ],
                            ),
                          ),
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
