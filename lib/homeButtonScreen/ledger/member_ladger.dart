import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/ledger/ledgerBillDetails.dart';
import 'package:societyuser_app/homeButtonScreen/ledger/ledgerReceiptDetails.dart';

// ignore: camel_case_types, must_be_immutable
class memberLedger extends StatefulWidget {
  memberLedger(
      {super.key,
      required this.flatno,
      required this.societyName,
      required this.username});
  String flatno;
  String societyName;
  String username;

  @override
  State<memberLedger> createState() => _memberLedgerState();
}

// ignore: camel_case_types
class _memberLedgerState extends State<memberLedger> {
  List<int> listOfIndex = [];
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
  // ignore: non_constant_identifier_names
  int BillMonthLength = 0;
  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());

  //List of Data with Bill Number
  List<dynamic> allDataWithBill = [];
  List<dynamic> allDataWithReceipt = [];

  List<dynamic> colums = [
    'Date',
    'Particulars',
    'Bills\nDebits',
    'Credits\nReceipts',
    'Balance',
  ];
  String flatno = '';
  String date = '';
  String date2 = '';
  String particulars = '';
  String amount = '';
  String month = '';
  List<List<dynamic>> rows = [];
  List<List<dynamic>> allRecepts = [];
  String phoneNum = '';
  @override
  initState() {
    super.initState();
    // LedgerList('siddivinayak');
    getBill(widget.societyName, widget.flatno).whenComplete(() {
      getReceipt(widget.societyName, widget.flatno).whenComplete(() {
        setListOfIndex();
        isLoading = false;
        setState(() {});
      });
    });
    // creditNodeData(widget.societyName ?? '', widget.username ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Member Ledger',
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
                          columnSpacing: 5,
                          columns: List.generate(5, (index) {
                            return DataColumn(
                              label: Text(
                                colums[index],
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                          rows: List.generate(rows.length * 2, (index1) {
                            return DataRow(
                              cells: List.generate(rows[0].length, (index2) {
                                // print(rows[index2]);
                                return DataCell(
                                  index1.isEven
                                      ? index2 == 1
                                          ? TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return LedgerBillDetailsPage(
                                                      flatno: widget.flatno,
                                                      name: widget.username,
                                                      societyName:
                                                          widget.societyName,
                                                      BillData: allDataWithBill[
                                                          listOfIndex[index1]],
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Text(
                                                'Bill No.\n ${rows[listOfIndex[index1]][index2]}',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Text(
                                              rows[listOfIndex[index1]]
                                                      [index2] ??
                                                  '0',
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
                                                    return LedgerReceiptDetailsPage(
                                                      flatno: widget.flatno,
                                                      name: widget.username,
                                                      societyName:
                                                          widget.societyName,
                                                      receiptData:
                                                          allDataWithReceipt[
                                                              listOfIndex[
                                                                  index1]],
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Text(
                                                'Receipt No.\n ${allRecepts[listOfIndex[index1]][index2]}',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Text(
                                              allRecepts[listOfIndex[index1]]
                                                      [index2] ??
                                                  '0',
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
            row.add(data['Bill Date']);
            row.add(data['Bill No']);
            row.add(data['Bill Amount']);
            row.add(data['0']);
            row.add(data['Bill Amount']);

            rows.add(row);

            break;
          }
        }
      }
    }
    isLoading = false;
    setState(() {});
  }

  void setListOfIndex() {
    for (int i = 0; i < rows.length; i++) {
      listOfIndex.add(i);
      listOfIndex.add(i);
    }
  }

  Future<void> getReceipt(String societyname, String flatno) async {
    isLoading = true;

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
            receipt.add(data['0']);
            receipt.add(data['Amount']);
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
    // print(allRecepts.length);
  }

  Future<void> creditNodeData() async {
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(widget.societyName)
        .collection('month')
        .get();
    List<dynamic> monthList =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('ladgerReceipt')
          .doc(widget.societyName)
          .collection('month')
          .doc(monthList[i])
          .get();
    }
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('creditNode')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .collection('memberName')
        .doc(widget.username)
        .collection('particular')
        .doc(widget.flatno)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      flatno = data['Flat No.'];
      amount = data['amount'];
      date = data['date'];
      particulars = data['particular'];
      monthyear = data['monthyear'];
      date2 = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

      setState(() {
        isLoading = false;
      });
    }
  }
}
