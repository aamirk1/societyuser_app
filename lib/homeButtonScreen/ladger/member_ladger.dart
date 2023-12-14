import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/ladger/ledgerBillDetails.dart';
import 'package:societyuser_app/homeButtonScreen/ladger/ledgerReceiptDetails.dart';

// ignore: camel_case_types, must_be_immutable
class memberLadger extends StatefulWidget {
  memberLadger({super.key, this.flatno, this.societyName, this.username});
  String? flatno;
  String? societyName;
  String? username;

  @override
  State<memberLadger> createState() => _memberLadgerState();
}

// ignore: camel_case_types
class _memberLadgerState extends State<memberLadger> {
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController electricController = TextEditingController();
  final TextEditingController billnoController = TextEditingController();
  final SplashService _splashService = SplashService();
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());
  String electric = '';
  String totalAmount = '';
  String billno = '';
  String water = '';
  bool isLoading = true;
  int BillMonthLength = 0;
  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());

  //List of Data with Bill Number
  List<dynamic> allDataWithBill = [];
  List<dynamic> allDataWithReceipt = [];

  List<dynamic> colums = [
    'Date',
    'Particulars',
    'Bills/Debits',
    'Credits / Receipts',
    'Balance',
  ];

  List<List<dynamic>> rows = [];
  List<List<dynamic>> allRecepts = [];

  @override
  initState() {
    super.initState();
    // ladgerList('siddivinayak');
    getBill(widget.societyName ?? '', widget.flatno ?? '').whenComplete(() {
      getReceipt(widget.societyName ?? '', widget.flatno ?? '')
          .whenComplete(() {
        isLoading = false;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Member Ladger',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // drawer: const MyDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DataTable(
                          // dataRowMinHeight: 10,
                          columnSpacing:
                              MediaQuery.of(context).size.width * 0.01,
                          columns: List.generate(5, (index) {
                            return DataColumn(
                              label: Text(
                                colums[index],
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                          rows: List.generate(rows.length, (index1) {
                            return DataRow(
                              cells: List.generate(rows[0].length, (index2) {
                                // print(rows[index2]);
                                print(allRecepts[index1][index2]);
                                return DataCell(
                                  //   Column(
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.only(top: 8.0),
                                  //       child: index2 == 1
                                  //           ? TextButton(
                                  //               onPressed: () {
                                  //                 print("Billlllllllll");
                                  //               },
                                  //               child: Text(rows[index1][index2],
                                  //                   style: const TextStyle(
                                  //                     fontSize: 10,
                                  //                   )))
                                  //           : Text(rows[index1][index2],
                                  //               style: const TextStyle(
                                  //                 fontSize: 10,
                                  //               )),
                                  //     ),
                                  //     index2 == 1
                                  //         ? TextButton(
                                  //             onPressed: () {
                                  //               print("Receipttttttt");
                                  //             },
                                  //             child: Text(
                                  //               allRecepts[index1][index2] ??
                                  //                   'N/A',
                                  //               style: const TextStyle(
                                  //                 fontSize: 10,
                                  //               ),
                                  //             ),
                                  //           )
                                  //         : Text(
                                  //             allRecepts[index1][index2] ?? 'N/A',
                                  //             style: const TextStyle(
                                  //               fontSize: 10,
                                  //             ),
                                  //           ),
                                  //   ],
                                  // )
                                  index1.isEven
                                      ? index2 == 1
                                          ? TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return LadgerBillDetailsPage(
                                                      flatno: widget.flatno,
                                                      name: widget.username,
                                                      societyName: widget.societyName,
                                                      BillData: allDataWithBill[index1],
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Text(
                                                rows[index1][index2] ?? 'N/A',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Text(rows[index1][index2] ?? 'N/A',
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ))
                                      : index2 == 1
                                          ? TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return LadgerReceiptDetailsPage(
                                                      flatno: widget.flatno,
                                                      name: widget.username,
                                                      societyName: widget.societyName,
                                                      ReceiptData: allDataWithReceipt[index1],
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Text(
                                                allRecepts[index1][index2] ??
                                                    'N/A',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Text(
                                              allRecepts[index1][index2] ??
                                                  'N/A',
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                );
                              }),
                            );
                          }),
                        ),
                      ),
                    ),
                  ]),
            ),
    );
  }

  Future<void> getBill(String societyname, String flatno) async {
    isLoading = true;

    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();

    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerBill')
        .doc(societyname)
        .collection('month')
        .get();
    List<dynamic> monthList =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    BillMonthLength = monthList.length;

    for (var i = 0; i < monthList.length; i++) {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('ladgerBill')
          .doc(societyname)
          .collection('month')
          .doc(monthList[i])
          .get();
      if (data.exists) {
        Map<String, dynamic> totalusers = data.data() as Map<String, dynamic>;
        List<dynamic> mapData = totalusers['data'];

        for (var data in mapData) {
          List<dynamic> row = [];

          if (flatno == data['Flat No.']) {
            allDataWithBill.add(data);
            row.add(data['Flat No.']);
            row.add(data['Bill No']);
            row.add(data['Maintenance Charges']);
            row.add(data['Municipal Tax']);
            row.add(data['Bill Amount']);

            rows.add(row);

            break;
          }
        }
      }
    }
    print('bill print $allDataWithBill');
    isLoading = false;
    setState(() {});
    print(rows.length);
  }

  Future<void> getReceipt(String societyname, String flatno) async {
    isLoading = true;

    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();

    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(societyname)
        .collection('month')
        .get();
    List<dynamic> monthList =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('ladgerReceipt')
          .doc(societyname)
          .collection('month')
          .doc(monthList[i])
          .get();
      if (data.exists) {
        Map<String, dynamic> totalusers = data.data() as Map<String, dynamic>;
        List<dynamic> mapData = totalusers['data'];

        for (var data in mapData) {
          List<dynamic> receipt = [];

          if (flatno == data['Flat No.']) {
            allDataWithReceipt.add(data);
            receipt.add(data['Receipt Date']);
            receipt.add(data['Flat No.']);
            receipt.add(data['ChqNo']);
            receipt.add(data['Bank Name']);
            receipt.add(data['Amount']);
            allRecepts.add(receipt);
            break;
          }
        }
      }
    }
    for (var i = 0; i < BillMonthLength - monthList.length; i++) {
      allRecepts.add(['N/A', 'N/A', 'N/A', 'N/A', 'N/A']);
    }
    // print('hellllloooo $allRecepts');
    isLoading = false;
    setState(() {});
    print(allRecepts.length);
  }
}
