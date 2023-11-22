import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class memberLadger extends StatefulWidget {
  memberLadger({super.key});

  @override
  State<memberLadger> createState() => _memberLadgerState();
}

class _memberLadgerState extends State<memberLadger> {
  List<dynamic> colums = [
    'Date',
    'Particulars',
    'Debit',
    'Credit',
    'Balance',
    'Status',
  ];

  List<dynamic> rows = [
    '15/01/2022',
    'Electricity Bill',
    '5000',
    '1000',
    '4000',
    'Paid',
  ];
  List<dynamic> rows2 = [
    '15/01/2022',
    'Receipt',
    '5000',
    '1000',
    '4000',
    'Paid',
  ];

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
      drawer: const MyDrawer(),
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.99,
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 5,
                shadowColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Expanded(
                  child: DataTable(
                    columnSpacing: 15,
                    columns: List.generate(6, (index) {
                      return DataColumn(
                        label: Text(
                          colums[index],
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                    rows: List.generate(2, (index1) {
                      return DataRow(
                        cells: List.generate(6, (index2) {
                          return DataCell(
                            index2 == 5
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 8, 77, 10),
                                      foregroundColor: buttonTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text('Pay'),
                                  )
                                : Text(
                                    rows[index2],
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
            )
          ]),
        ]),
      ),
    );
  }
}
