// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: must_be_immutable
class LedgerBillDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LedgerBillDetailsPage(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.BillData,
      required this.societyName,
      required this.name,
      required this.flatno});

  // ignore: non_constant_identifier_names
  Map<String, dynamic>? BillData;
  String? societyName;
  String? name;
  String? flatno;

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

  String? maintenanceCharges;
  String? municipalTax;
  String? legalNoticeCharges;
  String? parkingCharges;
  String? mhadaLeaseRent;
  String? repairFund;
  String? othercharges;
  String? sinkingfund;
  String? nonOccupancyChg;
  String? interest;
  String? towerBenefit;
  int billAmount = 0;
  String? billDate;
  dynamic totalDues = 0;
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
  List<dynamic> billDetails = [];

  var converter = NumberToCharacterConverter('en');
  String words = '';
  String phoneNum = '';
  void numbertochar() {
    words = converter.getTextForNumber(billAmount);
  }

  @override
  initState() {
    fetchData(widget.BillData!);
    numbertochar();
    getSociety(widget.societyName ?? '').whenComplete(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Center(child: Text('Bill Details')),
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
                        const Divider(
                          color: Colors.black,
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
                                      "Bill No.: ${widget.BillData!['Bill No'] == '' ? 'N/A' : widget.BillData!['Bill No']}",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      "Bill Date: ${widget.BillData!['Bill Date'] == '' ? 'N/A' : widget.BillData!['Bill Date']}",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Text(
                                      "Due Date: ${widget.BillData!['Due Date'] == '' ? 'N/A' : widget.BillData!['Due Date']}",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                  ])
                            ]),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.40,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  dividerThickness: 0,
                                  columnSpacing: 35,
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
                                        Text(billDetails[index] == ''
                                            ? '0'
                                            : billDetails[index]),
                                      )
                                    ]);
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Row(children: [
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  "Rupees $words Only",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              color: Colors.black,
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
                                            Text(":")
                                          ],
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text("$billAmount",
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                              Text("$billAmount",
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                              Text(
                                                  "${interest == '' ? 0 : interest}",
                                                  style: const TextStyle(
                                                      fontSize: 10)),
                                            ]),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                        color: Colors.black, thickness: 1),
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
                                                    fontSize: 12),
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
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                text:
                                    'Please pay your dues on or before Due Date. Otherwise Simple interest @21%p.a. will be charged on Arrears. Please Pay by cross cheques or via NEFT only in favouring ',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              TextSpan(
                                text: '$society_name',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text:
                                    ' and mention your flat number. If you have any descrepancy in the bill please contact society office.',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              )
                            ])))
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

  Future<void> fetchData(Map<String, dynamic> data) async {
    maintenanceCharges = data['Maintenance Charges'] ?? "N/A";
    municipalTax = data['Municipal Tax'] ?? "N/A";
    legalNoticeCharges = data['Legal Notice Charges'] ?? "N/A";
    parkingCharges = data['Parking Charges'] ?? "N/A";
    mhadaLeaseRent = data['Mhada Lease Rent'] ?? "N/A";
    repairFund = data['Repair Fund'] ?? "N/A";
    othercharges = data['Other Charges'] ?? "N/A";
    sinkingfund = data['Sinking Fund'] ?? "N/A";
    nonOccupancyChg = data['Non Occupancy Chg'] ?? "N/A";
    interest = data['Interest'] ?? "0";
    towerBenefit = data['TOWER BENEFIT'] ?? "N/A";
    billAmount = int.parse(data['Bill Amount'] ?? 0);

    totalDues = billAmount + int.parse(interest!.isEmpty ? '0' : interest!);

    billDetails.add(maintenanceCharges);
    billDetails.add(municipalTax);
    billDetails.add(legalNoticeCharges);
    billDetails.add(parkingCharges);
    billDetails.add(mhadaLeaseRent);
    billDetails.add(repairFund);
    billDetails.add(othercharges);
    billDetails.add(sinkingfund);
    billDetails.add(nonOccupancyChg);
    billDetails.add(interest);
    billDetails.add(towerBenefit);
    billDetails.add(billAmount);
    billDetails.add(totalDues);

    setState(() {});
    isLoading = false;
  }
}