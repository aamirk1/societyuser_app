// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: camel_case_types
class circular_notice extends StatefulWidget {
  circular_notice({super.key, this.flatno, this.societyName, this.username});
  String? flatno;
  String? societyName;
  String? username;

  @override
  State<circular_notice> createState() => _circular_noticeState();
}

// ignore: camel_case_types
class _circular_noticeState extends State<circular_notice> {
  List<String> notice = [
    'Notice 1',
    'Notice 2',
    'Notice 3',
    'Notice 4',
    'Notice 5',
    'Notice 6',
    'Notice 7',
    'Notice 8',
    'Notice 9',
    'Notice 10',
    'Notice 11',
    'Notice 12',
    'Notice 13',
    'Notice 14',
    'Notice 15',
    'Notice 16',
    'Notice 17',
    'Notice 18',
    'Notice 19',
    'Notice 20',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Circular Notice',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shadowColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dev Accounts -',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                        Text(
                          ' Society Manager App',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.15,
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Memeber Name: ${widget.username}"),
                              Text("Flat No.: ${widget.flatno}"),
                              Text("Society Name: ${widget.societyName}"),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.64,
                          child: ListView.builder(
                              itemCount: notice.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(notice[index]),
                                  onTap: () {
                                    // ignore: avoid_print
                                    print('noticeeeeeeee $index');
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
