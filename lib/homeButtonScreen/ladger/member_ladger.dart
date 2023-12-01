import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: camel_case_types
class memberLadger extends StatefulWidget {
  const memberLadger({super.key});

  @override
  State<memberLadger> createState() => _memberLadgerState();
}

// ignore: camel_case_types
class _memberLadgerState extends State<memberLadger> {
  final SplashService _splashService = SplashService();
  String monthyear = 'November 2023';
  String electric = '';
  List<dynamic> colums = [
    'Date',
    'Particulars',
    'Bills/Debits',
    'Credits / Receipts',
    'Balance',
  ];

  List<dynamic> rows = [
    '15/01/2022',
    'Bill',
    '5000',
    '1000',
    '4000',
  ];
  List<dynamic> rows2 = [
    '15/01/2022',
    'Receipt',
    '5000',
    '1000',
    '2000',
  ];
  @override
  initState() {
    super.initState();
    ladgerList('siddivinayak');
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
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width * 0.01,
                  columns: List.generate(5, (index) {
                    return DataColumn(
                      label: Text(
                        colums[index],
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                  rows: List.generate(24, (index1) {
                    return DataRow(
                      cells: List.generate(5, (index2) {
                        // print(rows[index2]);
                        return DataCell(index1.isEven
                            ? Text(rows[index2],
                                style: const TextStyle(
                                  fontSize: 10,
                                ))
                            : Text(
                                rows2[index2],
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ));
                      }),
                    );
                  }),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> ladgerList(String societyname) async {
    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();

    DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(monthyear)
        .get();
    Map<String, dynamic> tempdata =
        societyQuerySnapshot.data() as Map<String, dynamic>;
    List<dynamic> totalusers = tempdata['data'];

    for (var data in totalusers) {
      if (phoneNum == data['Mobile No.']) {
        electric = data['Electricity Chg.'];
        break;
      }
    }
  }
}
