import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';
import 'package:societyuser_app/homeButtonScreen/circular_notice.dart';
import 'package:societyuser_app/homeButtonScreen/complaints.dart';
import 'package:societyuser_app/homeButtonScreen/member_ladger.dart';
import 'package:societyuser_app/homeButtonScreen/noc_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<dynamic> cols = [
  'month',
  'Duration',
  'Amount',
  'Status',
];
List<dynamic> rows = [
  'jan',
  '15 days',
  '5000',
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Society User App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const MyDrawer(),
      body: SizedBox(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DataTable(
                        columnSpacing: 35,
                        columns: List.generate(4, (index) {
                          return DataColumn(
                              label: Text(cols[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)));
                        }),
                        rows: List.generate(1, (index1) {
                          return DataRow(
                              cells: List.generate(4, (index2) {
                            return DataCell(
                              index2 == 3
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: buttonTextColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text('Pay'))
                                  : Text(
                                      rows[index2],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                            );
                          }));
                        })),
                  ),
                )
              ]),
            ]),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size(370, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return memberLadger();
                            }),
                          );
                        },
                        child: const Text(
                          'Member Ladger',
                          style: TextStyle(fontSize: 20),
                        ))
                  ]),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(370, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const circular_notice();
                      }),
                    );
                  },
                  child: const Text(
                    'Circular Notices',
                    style: TextStyle(fontSize: 20),
                  ))
            ]),
            const SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(370, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const nocPage();
                      }),
                    );
                  },
                  child: const Text(
                    'NOC',
                    style: TextStyle(fontSize: 20),
                  ))
            ]),
            const SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(370, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const complaints();
                      }),
                    );
                  },
                  child: const Text(
                    'Complaints',
                    style: TextStyle(fontSize: 20),
                  ))
            ])
          ],
        ),
      ),
    );
  }
}
