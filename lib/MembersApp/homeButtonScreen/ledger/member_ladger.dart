import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/creditNoteDetails.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/debitNoteDetails.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/ledgerBillDetails.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/ledgerReceiptDetails.dart';

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
  bool isLoading = false;

  // ignore: non_constant_identifier_names

  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());

  //List of Data with Bill Number
  List<dynamic> allDataWithBill = [];
  List<dynamic> allDataWithReceipt = [];
  List<dynamic> monthList = [];
  List<List<dynamic>> rowList = [];
  List<String> particulartsLableList = [];
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
  String debitnoteNumber = '';
  String creditnoteNumber = '';
  String amount = '';
  String totalBillAmount = '';
  String totalCretitAmount = '0';
  String totalDebititAmount = '0';
  String totalReceiptAmount = '';
  String month = '';
  List<List<dynamic>> billNoList = [];
  List<List<dynamic>> creditList = [];
  List<List<dynamic>> debitList = [];
  List<List<dynamic>> receiptList = [];

  String phoneNum = '';
  @override
  initState() {
    fetchData().whenComplete(() => setState(() {
          isLoading = false;
        }));

    super.initState();
  }

  Future<void> fetchData() async {
    await getBill(widget.societyName, widget.flatno);
    await getReceipt(widget.societyName, widget.flatno);
    await debitNoteData();
    await creditNoteData();
    await mergeAllList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: appBarBgColor,
          title: const Text(
            'Member Ledger',
            style: TextStyle(color: Colors.white),
          ),
        ),
        // drawer: const MyDrawer(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer(builder: (context, value, child) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.98,
                                  child: DataTable(
                                    headingRowColor:
                                        const WidgetStatePropertyAll(
                                            Color.fromARGB(255, 48, 51, 228)),
                                    // dataRowMinHeight: 10,
                                    columnSpacing: 5,
                                    columns: List.generate(5, (index) {
                                      return DataColumn(
                                        label: Text(
                                          colums[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }),
                                    rows: List.generate(
                                      rowList.length,
                                      (index1) {
                                        return DataRow(
                                          cells: List.generate(
                                            colums.length,
                                            (index2) {
                                              print(rowList[index1][index2]);
                                              return DataCell(
                                                index2 == 1
                                                    ? particulartsLableList[
                                                                index1] ==
                                                            '5_Bill No'
                                                        ? TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                    ),
                                                                    backgroundColor:
                                                                        buttonColor,
                                                                    fixedSize:
                                                                        const Size(
                                                                            70,
                                                                            40)),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return LedgerBillDetailsPage(
                                                                      flatno: widget
                                                                          .flatno,
                                                                      name: widget
                                                                          .username,
                                                                      societyName:
                                                                          widget
                                                                              .societyName,
                                                                      billDate:
                                                                          rowList[index1]
                                                                              [
                                                                              0],
                                                                      billNo:
                                                                          rowList[index1]
                                                                              [
                                                                              1],
                                                                      billAmount:
                                                                          rowList[index1]
                                                                              [
                                                                              2],
                                                                      dueDate:
                                                                          rowList[index1]
                                                                              [
                                                                              5],
                                                                      interest:
                                                                          rowList[index1]
                                                                              [
                                                                              6],
                                                                      legalNoticeCharges:
                                                                          rowList[index1]
                                                                              [
                                                                              7],
                                                                      maintenanceCharges:
                                                                          rowList[index1]
                                                                              [
                                                                              8],
                                                                      mhadaLeaseRent:
                                                                          rowList[index1]
                                                                              [
                                                                              9],
                                                                      municipalTax:
                                                                          rowList[index1]
                                                                              [
                                                                              10],
                                                                      nonOccupancyChg:
                                                                          rowList[index1]
                                                                              [
                                                                              11],
                                                                      othercharges:
                                                                          rowList[index1]
                                                                              [
                                                                              12],
                                                                      parkingCharges:
                                                                          rowList[index1]
                                                                              [
                                                                              13],
                                                                      repairFund:
                                                                          rowList[index1]
                                                                              [
                                                                              14],
                                                                      sinkingFund:
                                                                          rowList[index1]
                                                                              [
                                                                              15],
                                                                      towerBenefit:
                                                                          rowList[index1]
                                                                              [
                                                                              16],
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              '${particulartsLableList[index1].split('5_').join('')}\n ${rowList[index1][index2]}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      // backgroundColor:
                                                                      //     Colors.amber,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )
                                                        : particulartsLableList[
                                                                    index1] ==
                                                                '2_Receipt No.'
                                                            ? TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                        shape:
                                                                            const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(5),
                                                                          ),
                                                                        ),
                                                                        backgroundColor:
                                                                            buttonColor,
                                                                        fixedSize: const Size(
                                                                            70,
                                                                            40)),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return LedgerReceiptDetailsPage(
                                                                      flatno: widget
                                                                          .flatno,
                                                                      name: widget
                                                                          .username,
                                                                      societyName:
                                                                          widget
                                                                              .societyName,
                                                                      receiptNo:
                                                                          rowList[index1]
                                                                              [
                                                                              7],
                                                                      receiptDate:
                                                                          rowList[index1]
                                                                              [
                                                                              0],
                                                                      amount:
                                                                          rowList[index1]
                                                                              [
                                                                              3],
                                                                      checkDate:
                                                                          rowList[index1]
                                                                              [
                                                                              6],
                                                                      cheqNo:
                                                                          rowList[index1]
                                                                              [
                                                                              8],
                                                                      bankName:
                                                                          rowList[index1]
                                                                              [
                                                                              5],

                                                                      //  receiptData: {},
                                                                    );
                                                                  }));
                                                                },
                                                                child: Text(
                                                                  '${particulartsLableList[index1].split('2_').join('')}\n ${rowList[index1][index2]}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )
                                                            : particulartsLableList[
                                                                        index1] ==
                                                                    'Debit Note'
                                                                ? TextButton(
                                                                    style: TextButton.styleFrom(
                                                                        shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(5),
                                                                          ),
                                                                        ),
                                                                        backgroundColor: buttonColor,
                                                                        fixedSize: const Size(70, 40)),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder:
                                                                              (context) {
                                                                        return DebitNoteDetails(
                                                                          flatno:
                                                                              widget.flatno,
                                                                          name:
                                                                              widget.username,
                                                                          societyName:
                                                                              widget.societyName,
                                                                          amount:
                                                                              rowList[index1][2],
                                                                          date: rowList[index1]
                                                                              [
                                                                              0],
                                                                          debitNoteNumber:
                                                                              rowList[index1][2],
                                                                          particulars:
                                                                              rowList[index1][1],
                                                                          month:
                                                                              rowList[index1][6],
                                                                        );
                                                                      }));
                                                                    },
                                                                    child: Text(
                                                                      '${particulartsLableList[index1]}\n${rowList[index1][index2]}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  )
                                                                : TextButton(
                                                                    style: TextButton.styleFrom(
                                                                        shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(5),
                                                                          ),
                                                                        ),
                                                                        backgroundColor: buttonColor,
                                                                        fixedSize: const Size(70, 40)),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder:
                                                                              (context) {
                                                                        return CreditNoteDetails(
                                                                          flatno:
                                                                              widget.flatno,
                                                                          name:
                                                                              widget.username,
                                                                          societyName:
                                                                              widget.societyName,
                                                                          amount:
                                                                              rowList[index1][3],
                                                                          date: rowList[index1]
                                                                              [
                                                                              0],
                                                                          creditNoteNumber:
                                                                              rowList[index1][6],
                                                                          particulars:
                                                                              rowList[index1][1],
                                                                        );
                                                                      }));
                                                                    },
                                                                    child: Text(
                                                                      '${particulartsLableList[index1]}\n ${rowList[index1][index2]}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  )
                                                    : Text(
                                                        rowList[index1]
                                                                [index2] ??
                                                            '0',
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Column(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(totalDebititAmount,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          Text(totalCretitAmount,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          Text(totalBillAmount,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }));
  }

  Future<void> getBill(String societyname, String flatno) async {
    billNoList.clear();
    isLoading = true;

    phoneNum = await _splashService.getPhoneNum();

    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerBill')
        .doc(societyname)
        .collection('month')
        .get();
    List<dynamic> monthList =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

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

          if (flatno == data['3_Flat No.']) {
            allDataWithBill.add(data);

            String billAmount = data['6_Bill Amount'].split(' ')[0];
            // String payableAmount = data['8_Payable'].split(' ')[0];
            String payableAmount = 0.toString();
            totalBillAmount = totalBillAmount +
                (double.parse(billAmount) - double.parse(payableAmount))
                    .toString();

            totalDebititAmount =
                (double.parse(totalDebititAmount) + double.parse(billAmount))
                    .toString();
            // print('totalDebititAmount111 $totalDebititAmount');

            row.add(data['1_Bill Date'] ?? 'N/A');
            row.add(data['5_Bill No'] ?? '0');
            row.add(billAmount);
            row.add(payableAmount);
            row.add(totalBillAmount);
            row.add(data['2_Due Date'] ?? 'N/A');
            row.add(data['7_Interest'] ?? 'N/A');
            row.add(data['Legal Notice Charges'] ?? 'N/A');
            row.add(data['Maintenance Charges'] ?? 'N/A');
            row.add(data['Mhada Lease Rent'] ?? 'N/A');
            row.add(data['Municipal Tax'] ?? 'N/A');
            row.add(data['Non Occupancy Charges'] ?? 'N/A');
            row.add(data['Other Charges'] ?? 'N/A');
            row.add(data['Parking Charges'] ?? 'N/A');
            row.add(data['Repair Fund'] ?? 'N/A');
            row.add(data['Sinking Fund'] ?? 'N/A');
            row.add(data['TOWER BENEFIT'] ?? 'N/A');

            billNoList.add(row);
          }
        }
      }
    }
  }

  Future<void> getReceipt(String societyname, String flatno) async {
    print('here $totalBillAmount');
    receiptList.clear();
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

          if (flatno == data['1_Flat No.']) {
            allDataWithReceipt.add(data);

            String receiptAmount = data['5_Amount'].split(' ')[0];
            // String payableAmount = data['8_Payable'].split(' ')[0];
            String payableAmount = 0.toString();
            totalBillAmount = (double.parse(totalBillAmount) +
                    double.parse(payableAmount) -
                    double.parse(receiptAmount))
                .toString();
            totalCretitAmount =
                (double.parse(totalCretitAmount) + double.parse(receiptAmount))
                    .toString();

            receipt.add(data['3_Receipt Date'] ?? 'N/A');
            receipt.add(data['1_Flat No.'] ?? 'N/A');
            receipt.add(payableAmount);
            receipt.add(receiptAmount);
            receipt.add(totalBillAmount);
            receipt.add(data['Bank Name'] ?? 'N/A');
            receipt.add(data['7_ChqDate'] ?? 'N/A');
            receipt.add(data['2_Receipt No'] ?? '0');
            receipt.add(data['6_ChqNo'] ?? 'N/A');
            receiptList.add(receipt);
          }
        }
      }
    }
    if (billNoList.length > receiptList.length) {
      int loopLen = billNoList.length - receiptList.length;
      for (var i = 0; i < loopLen; i++) {
        receiptList.add(['N/A', '0', '0', '0', '0']);
      }
    }
    // print(allRecepts.length);
  }

  Future<void> debitNoteData() async {
    debitList.clear();
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(widget.societyName)
        .collection('month')
        .get();
    monthList = societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('debitNote')
          .doc(widget.societyName)
          .collection('month')
          .doc(monthList[i])
          .collection('memberName')
          .doc(widget.username)
          .collection('noteNumber')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> singleRow = [];
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        flatno = data['Flat No.'];
        amount = data['amount'];
        date = data['date'];
        particulars = data['particular'];
        debitnoteNumber = data['noteNumber'];
        monthyear = data['month'];
        date2 = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

        String debitAmount = data['amount'].split(' ')[0];
        String payableAmount = 0.toString();
        totalBillAmount = (double.parse(totalBillAmount) +
                double.parse(debitAmount) -
                double.parse(payableAmount))
            .toString();

        totalDebititAmount =
            (double.parse(totalDebititAmount) + double.parse(debitAmount))
                .toString();
        // print('totalDebititAmount22 - $totalDebititAmount');
        singleRow.add(date2);
        singleRow.add(particulars);
        singleRow.add(debitAmount);
        singleRow.add(payableAmount);
        singleRow.add(totalBillAmount);
        singleRow.add(monthyear);
        singleRow.add(debitnoteNumber);
        debitList.add(singleRow);
      }
    }
    print('debitList - $debitList');
  }

  Future<void> creditNoteData() async {
    creditList.clear();
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('creditNote')
        .doc(widget.societyName)
        .collection('month')
        .get();
    monthList = societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('creditNote')
          .doc(widget.societyName)
          .collection('month')
          .doc(monthList[i])
          .collection('memberName')
          .doc(widget.username)
          .collection('noteNumber')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> singleRow = [];
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        flatno = data['Flat No.'];
        amount = data['amount'];
        date = data['date'];
        particulars = data['particular'];
        creditnoteNumber = data['noteNumber'];
        monthyear = data['month'];
        date2 = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));

        String creditAmount = data['amount'].split(' ')[0];
        String payableAmount = 0.toString();
        totalBillAmount = (double.parse(totalBillAmount) +
                double.parse(payableAmount) -
                double.parse(creditAmount))
            .toString();

        totalCretitAmount =
            (double.parse(totalCretitAmount) + double.parse(creditAmount))
                .toString();

        singleRow.add(date2);
        singleRow.add(particulars);
        singleRow.add(payableAmount);
        singleRow.add(creditAmount);
        singleRow.add(totalBillAmount);
        singleRow.add(monthyear);
        singleRow.add(creditnoteNumber);
        creditList.add(singleRow);
      }
    }
    if (debitList.length > creditList.length) {
      int loopLen = debitList.length - creditList.length;
      for (var i = 0; i < loopLen; i++) {
        creditList.add(['N/A', 'N/A', 'N/A', 'N/A', 'N/A']);
      }
    }
    print('creditList - ${creditList}');
  }

  Future<void> mergeAllList() async {
    List<List<dynamic>> listOfRows = [];
    for (int i = 0; i < billNoList.length; i++) {
      listOfRows.add(billNoList[i]);
      particulartsLableList.add('5_Bill No');
      listOfRows.add(receiptList[i]);
      particulartsLableList.add('2_Receipt No.');
      if (creditList.length >= i + 1) {
        listOfRows.add(debitList[i]);
        particulartsLableList.add('Debit Note');
        listOfRows.add(creditList[i]);
        particulartsLableList.add('Credit Note');
      }
    }

    rowList = listOfRows;

    print('rowListtttt22 - ${rowList}');

    print(listOfRows);
  }
}
