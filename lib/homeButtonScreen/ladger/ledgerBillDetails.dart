import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: must_be_immutable
class LadgerBillDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LadgerBillDetailsPage(
      {super.key,
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
  State<LadgerBillDetailsPage> createState() => _LadgerBillDetailsPageState();
}

class _LadgerBillDetailsPageState extends State<LadgerBillDetailsPage> {
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
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  List<String> colums = [
    'Sr. No.',
    'Particulars of \n Changes',
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
  @override
  initState() {
    scrollController1.addListener(() {
      scrollController2.jumpTo(scrollController1.offset);
    });

    scrollController2.addListener(() {
      scrollController1.jumpTo(scrollController2.offset);
    });
    fetchData(widget.BillData!);

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
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$society_name',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
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
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.50,
                                        child: Text(
                                          "Name: ${widget.name}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Flat No.: ${widget.flatno}"),
                                      Text(
                                          "Bill No.: ${widget.BillData!['Bill No']}"),
                                      Text(
                                          "Bill Date: ${widget.BillData!['Bill No']}"),
                                      Text(
                                          "Due Date: ${widget.BillData!['Bill No']}")
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
                                height:
                                    MediaQuery.of(context).size.height * 0.60,
                                child: SingleChildScrollView(
                                  controller: scrollController1,
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
                                    ],
                                    rows: List.generate(11, (index) {
                                      return DataRow(cells: [
                                        DataCell(
                                          Text((index + 1).toString()),
                                        ),
                                        DataCell(
                                          Text(particulars[index]),
                                        )
                                      ]);
                                    }),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.60,
                                child: SingleChildScrollView(
                                  controller: scrollController2,
                                  child: DataTable(
                                    dividerThickness: 0,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'Amount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(11, (index1) {
                                      return DataRow(
                                        cells: List.generate(1, (index2) {
                                          return DataCell(
                                            Text(billDetails[index1]),
                                          );
                                        }),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
    maintenanceCharges = data['Maintenance Charges'] ?? "N/A";
    municipalTax = data['Municipal Tax'] ?? "N/A";
    legalNoticeCharges = data['Legal Notice Charges'] ?? "N/A";
    parkingCharges = data['Parking Charges'] ?? "N/A";
    mhadaLeaseRent = data['Mhada Lease Rent'] ?? "N/A";
    repairFund = data['Repair Fund'] ?? "N/A";
    othercharges = data['Other Charges'] ?? "N/A";
    sinkingfund = data['Sinking Fund'] ?? "N/A";
    nonOccupancyChg = data['Non Occupancy Charges'] ?? "N/A";
    interest = data['Interest'] ?? "N/A";
    towerBenefit = data['TOWER BENEFIT'] ?? "N/A";

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
    print(billDetails);
    setState(() {});
    isLoading = false;
  }
}
