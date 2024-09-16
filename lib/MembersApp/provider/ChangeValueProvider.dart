// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';

class ChangeValue extends ChangeNotifier {
  String _grandTotalBillAmount = '0';
  String get grandTotalBillAmount => _grandTotalBillAmount;

  void setGrandTotalBillAmount(String value) {
    _grandTotalBillAmount = value;
    notifyListeners();
  }

  // Define the methods that fetch data
  List<int> listOfIndex = [];
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController electricController = TextEditingController();
  final TextEditingController billnoController = TextEditingController();
  final SplashService _splashService = SplashService();
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());

  String totalBillAmount = '';
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

  String flatno = '';
  String date = '';
  String date2 = '';
  String particulars = '';
  String debitnoteNumber = '';
  String creditnoteNumber = '';
  String amount = '';
  String totalReceiptAmount = '';
  String month = '';
  List<List<dynamic>> billNoList = [];
  List<List<dynamic>> creditList = [];
  List<List<dynamic>> debitList = [];
  List<List<dynamic>> receiptList = [];

  String phoneNum = '';
  Future<void> getBill(
      String societyname, String flatno, String username) async {
    billNoList.clear();

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
      print('bill complete');
    }
  }

  Future<void> getReceipt(
      String societyname, String flatno, String username) async {
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

  Future<void> debitNoteData(
      String societyname, String flatno, String username) async {
    debitList.clear();
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('debitNote')
        .doc(societyname)
        .collection('month')
        .get();
    monthList = societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('debitNote')
          .doc(societyname)
          .collection('month')
          .doc(monthList[i])
          .collection('memberName')
          .doc(username)
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

  Future<void> creditNoteData(
      String societyname, String flatno, String username) async {
    creditList.clear();
    QuerySnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('creditNote')
        .doc(societyname)
        .collection('month')
        .get();
    monthList = societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (var i = 0; i < monthList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('creditNote')
          .doc(societyname)
          .collection('month')
          .doc(monthList[i])
          .collection('memberName')
          .doc(username)
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
        setGrandTotalBillAmount(totalBillAmount);
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

  Future<void> fetchData(
      String societyName, String flatno, String username) async {
    await getBill(societyName, flatno, username);
    await getReceipt(societyName, flatno, username);
    await debitNoteData(societyName, flatno, username);
    await creditNoteData(societyName, flatno, username);
    await mergeAllList();
    notifyListeners(); // Notify listeners when data is fetched
  }
}
