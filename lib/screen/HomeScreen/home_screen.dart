import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/complaints.dart';
import 'package:societyuser_app/homeButtonScreen/ladger/member_ladger.dart';
import 'package:societyuser_app/homeButtonScreen/noc/noc_page.dart';
import 'package:societyuser_app/homeButtonScreen/notice/circular_notice.dart';

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
  SplashService _splashService = SplashService();
  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController flatnoController = TextEditingController();

  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // final TextEditingController _controllerSociety = TextEditingController();

  // Boolean value fro updating and setting user role in database
  bool userExist = false;
  List<dynamic> societyList = [];
  List<dynamic> memberList = [];
  String name = '';
  String status = '';
  String flatno = '';
  @override
  void initState() {
    _splashService.getPhoneNum();
    // TODO: implement initState
    super.initState();
  }

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
      drawer: MyDrawer(flatno: flatno, username: name),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,

                // height: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Dev Accounts',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller: _societyNameController,
                                            decoration: const InputDecoration(
                                                labelText: 'Select Society',
                                                border: OutlineInputBorder())),
                                    suggestionsCallback: (pattern) async {
                                      return await getSocietyList();
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(
                                          suggestion.toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      _societyNameController.text =
                                          suggestion.toString();
                                      getMemberName(suggestion.toString());

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => societyDetails(
                                      //         societyNames: suggestion.toString()),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: Text(
                                    "Society Name: ${_societyNameController.text}"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child:
                                    Text("Flat No.: ${flatnoController.text}"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: Text(
                                    "Memeber Name: ${usernameController.text}"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.90,
                                child: Text("Status: ${statusController.text}"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DataTable(
                        columnSpacing: MediaQuery.of(context).size.width * 0.06,
                        columns: List.generate(4, (index) {
                          return DataColumn(
                              label: Text(cols[index],
                                  style: const TextStyle(
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
                                        child: const Text('Pay'))
                                    : Text(
                                        rows[index2],
                                        style: const TextStyle(
                                          fontSize: 15,
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
              ]),
              const Divider(
                color: Colors.grey,
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // minimumSize: const Size(370, 50),
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
                    ),
                  ),
                ),
              ]),

              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // minimumSize: const Size(370, 50),
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
                    ),
                  ),
                )
              ]),

              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // minimumSize: const Size(370, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return nocPage(
                              flatno: flatnoController.text,
                              societyName: _societyNameController.text);
                        }),
                      );
                    },
                    child: const Text(
                      'NOC',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // minimumSize: const Size(370, 50),
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
                      )),
                )
              ]),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    // padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: buttonTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // minimumSize: const Size(370, 50),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) {
                          //     return const notice();
                          //   }),
                          // );
                        },
                        child: const Text(
                          'Other',
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> getSocietyList() async {
    String phoneNum = '';
    List<dynamic> temp = [];
    phoneNum = await _splashService.getPhoneNum();

    QuerySnapshot societyQuerySnapshot =
        await FirebaseFirestore.instance.collection('members').get();

    List<String> allSociety =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < allSociety.length; i++) {
      bool isUserPresent = false;
      DocumentSnapshot dataDocumentSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(allSociety[i])
          .get();

      Map<String, dynamic> tempData =
          dataDocumentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> dataList = tempData['data'];

      for (var data in dataList) {
        if (phoneNum == data['Mobile No.']) {
          isUserPresent = true;
          break;
        }
      }
      if (isUserPresent) {
        temp.add(allSociety[i]);
      }
    }
    societyList = temp;
    if (societyList.isEmpty) {
      societyList.add(['No Data Found']);
    }
    return societyList;
  }

  Future<void> getMemberName(String selectedSociety) async {
    String phoneNum = '';

    List<dynamic> temp = [];
    phoneNum = await _splashService.getPhoneNum();

    QuerySnapshot societyQuerySnapshot =
        await FirebaseFirestore.instance.collection('members').get();

    List<String> allSociety =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < allSociety.length; i++) {
      bool isUserPresent = false;
      DocumentSnapshot dataDocumentSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(selectedSociety)
          .get();

      Map<String, dynamic> tempData =
          dataDocumentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> dataList = tempData['data'];

      for (var data in dataList) {
        if (phoneNum == data['Mobile No.']) {
          name = data['Member Name'];
          status = data['Status'];
          flatno = data['Flat No.'];

          setState(() {
            flatnoController.text = flatno;
            usernameController.text = name;
            statusController.text = status;
          });
          break;
        }
      }
    }
  }
}
