import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/common_widget/drawer.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/complaint/complaints.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/gatePass/gatePass.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/member_ladger.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/noc/noc_page.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/notice/circular_notice.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/others/others.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/serviceProvider/serviceProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isSocietySelected = false;
List<dynamic> row = [
  'Dues',
  'Ledger',
];
List<dynamic> cols = [
  '5000',
  '15 days',
];

class _HomeScreenState extends State<HomeScreen> {
  final SplashService _splashService = SplashService();
  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController billAmountController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController flatnoController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // final TextEditingController _controllerSociety = TextEditingController();

  // Boolean value fro updating and setting user role in database
  bool userExist = false;
  List<dynamic> societyList = [];
  List<dynamic> memberList = [];
  String name = '';
  String username = '';
  String status = '';
  String billAmount = '';
  String flatno = '';
  String mobile = '';

  bool isLoading = false;
  bool isDataAvailable = false;
  String phoneNum = '';
  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());
  @override
  void initState() {
    _splashService.getPhoneNum();
    super.initState();
  }

  List<String> buttons = [
    'MEMBER LEDGER',
    'CIRCULAR/NOTICE',
    'NOC MANAGEMENT',
    'GRIEVANCE / COMPLAINT',
    // 'RESIDENT MANAGEMENT',
    'SERVICE PROVIDER MANAGEMENT',
    'GATE PASS',
    'OTHERS'
  ];
  List<Widget Function(String, String, String)> screens = [
    (flatno, society, name) => memberLedger(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    (flatno, society, name) => circular_notice(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    (flatno, society, name) => nocPage(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    (flatno, society, name) => Complaints(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    // (flat, society, username) => const ResidentManagement(),
    (flatno, society, name) => ServiceProvider(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    (flatno, society, name) => GatePass(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    (flat, society, username) => const Others(),
  ];
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
      drawer: MyDrawer(
          flatno: flatno,
          username: name,
          societyName: _societyNameController.text,
          mobile: mobile),
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
                              child: Row(
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
                                      getMemberName(suggestion.toString())
                                          .whenComplete(() {
                                        getCurrentBill(suggestion.toString());
                                        isSocietySelected = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isLoading
                            ? const Padding(
                                padding: EdgeInsets.only(top: 50.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          child: Text(
                                              "Flat No.: ${flatnoController.text}"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          child: Text(
                                              "Status: ${statusController.text}"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
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
                        columnSpacing: 155,
                        columns: [
                          const DataColumn(
                              label: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Dues',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                          DataColumn(
                              label: Text('Rs: ${billAmountController.text}')),
                        ],
                        dividerThickness: 2,
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              TextButton(
                                onPressed: () {
                                  if (isSocietySelected) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return memberLedger(
                                          flatno: flatnoController.text,
                                          societyName:
                                              _societyNameController.text,
                                          username: usernameController.text,
                                        );
                                      }),
                                    );
                                  } else {
                                    customDialogBox();
                                  }
                                },
                                child: const Text(
                                  'Ledger',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            DataCell(ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green)),
                              onPressed: () {},
                              child: const Text('Pay'),
                            )),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ]),
              ]),
              const SizedBox(
                height: 5,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                        itemCount: buttons.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {
                                if (isSocietySelected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => screens[index](
                                          flatnoController.text,
                                          _societyNameController.text,
                                          usernameController.text),
                                    ),
                                  );
                                } else {
                                  customDialogBox();
                                }
                              },
                              child: Text(buttons[index]));
                        })),
              ]),
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
    setState(() {
      isLoading = true;
    });
    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();

    QuerySnapshot societyQuerySnapshot =
        await FirebaseFirestore.instance.collection('members').get();

    List<String> memeberName =
        societyQuerySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < memeberName.length; i++) {
      // ignore: unused_local_variable
      bool isUserPresent = false;
      DocumentSnapshot dataDocumentSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(selectedSociety)
          .get();
      if (dataDocumentSnapshot.exists) {
        Map<String, dynamic> tempData =
            dataDocumentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> dataList = tempData['data'];

        for (var data in dataList) {
          if (phoneNum == data['Mobile No.']) {
            name = data['Member Name'];
            status = data['Status'] ?? 'Not Available';
            flatno = data['Flat No.'];
            mobile = data['Mobile No.'];

            flatnoController.text = flatno;
            usernameController.text = name;
            mobileController.text = mobile;
            statusController.text = status;

            break;
          }
        }
        setState(() {});
        isLoading = false;
      }
    }
  }

  void customDialogBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Select Society First',
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  )),
              // TextButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: const Text('Yes'))
            ],
          );
        });
  }

  Future<void> getCurrentBill(String selectedSociety) async {
    // ignore: unused_local_variable
    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();

    DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('ladgerBill')
        .doc(_societyNameController.text)
        .collection('month')
        .doc(currentmonth)
        .get();

    if (societyQuerySnapshot.exists) {
      Map<String, dynamic> allSociety =
          societyQuerySnapshot.data() as Map<String, dynamic>;

      List<dynamic> dataList = allSociety['data'];

      for (var data in dataList) {
        if (flatnoController.text == data['Flat No.']) {
          billAmount = data['Bill Amount'];

          setState(() {
            billAmountController.text = billAmount;
          });
          break;
        }
      }
    }
  }
}





// Future<List<dynamic>> getSocietyList() async {
//     String phoneNum = '';
//     List<dynamic> temp = [];
//     phoneNum = await _splashService.getPhoneNum();

//     QuerySnapshot societyQuerySnapshot =
//         await FirebaseFirestore.instance.collection('members').get();

//     List<String> allSociety =
//         societyQuerySnapshot.docs.map((e) => e.id).toList();

//     for (int i = 0; i < allSociety.length; i++) {
//       bool isUserPresent = false;
//       DocumentSnapshot dataDocumentSnapshot = await FirebaseFirestore.instance
//           .collection('members')
//           .doc(allSociety[i])
//           .get();

//       Map<String, dynamic> tempData =
//           dataDocumentSnapshot.data() as Map<String, dynamic>;
//       List<dynamic> dataList = tempData['data'];

//       for (var data in dataList) {
//         if (phoneNum == data['Mobile No.']) {
//           isUserPresent = true;
//           break;
//         }
//       }
//       if (isUserPresent) {
//         temp.add(allSociety[i]);
//       }
//     }
//     societyList = temp;
//     if (societyList.isEmpty) {
//       societyList.add(['No Data Found']);
//     }
//     return societyList;
//   }

//   Future<void> getMemberName(String selectedSociety) async {
//     isDataAvailable = false;
//     setState(() {
//       isLoading = true;
//     });

//     phoneNum = await _splashService.getPhoneNum();

//     QuerySnapshot societyQuerySnapshot =
//         await FirebaseFirestore.instance.collection('members').get();

//     List<String> memeberName =
//         societyQuerySnapshot.docs.map((e) => e.id).toList();

//     for (int i = 0; i < memeberName.length; i++) {
//       // ignore: unused_local_variable
//       bool isUserPresent = false;
//       DocumentSnapshot dataDocumentSnapshot = await FirebaseFirestore.instance
//           .collection('members')
//           .doc(selectedSociety)
//           .get();
//       if (dataDocumentSnapshot.exists) {
//         Map<String, dynamic> tempData =
//             dataDocumentSnapshot.data() as Map<String, dynamic>;
//         List<dynamic> dataList = tempData['data'];

//         if (dataDocumentSnapshot.exists) {
//           isDataAvailable = true;
//           Map<String, dynamic> tempData =
//               dataDocumentSnapshot.data() as Map<String, dynamic>;
//           List<dynamic> dataList = tempData['data'];

//           for (var data in dataList) {
//             if (phoneNum == data['Mobile No.']) {
//               name = data['Member Name'];
//               status = data['Status'] ?? 'N/A';
//               flatno = data['Flat No.'];

//               flatnoController.text = flatno;
//               usernameController.text = name;
//               statusController.text = status ?? '';
//               for (var data in dataList) {
//                 if (phoneNum == data['Mobile No.']) {
//                   name = data['Member Name'];
//                   status = data['Status'];
//                   flatno = data['Flat No.'];
//                   mobile = data['Mobile No.'];

//                   flatnoController.text = flatno;
//                   usernameController.text = name;
//                   mobileController.text = mobile;
//                   statusController.text = status!;

//                   break;
//                 }
//               }
//               setState(() {});
//               isLoading = false;
//             }
//           }
//         }

//         void customDialogBox() {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: const Text(
//                     'Select Society First',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text(
//                           'OK',
//                           style: TextStyle(color: Colors.black),
//                         )),
//                     // TextButton(
//                     //     onPressed: () {
//                     //       Navigator.pop(context);
//                     //     },
//                     //     child: const Text('Yes'))
//                   ],
//                 );
//               });
//         }

//         Future<void> getCurrentBill(String selectedSociety) async {
//           // ignore: unused_local_variable
//           String phoneNum = '';

//           phoneNum = await _splashService.getPhoneNum();

//           DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore
//               .instance
//               .collection('ladgerBill')
//               .doc(_societyNameController.text)
//               .collection('month')
//               .doc(currentmonth)
//               .get();

//           if (societyQuerySnapshot.exists) {
//             Map<String, dynamic> allSociety =
//                 societyQuerySnapshot.data() as Map<String, dynamic>;

//             List<dynamic> dataList = allSociety['data'];

//             for (var data in dataList) {
//               if (flatnoController.text == data['Flat No.']) {
//                 billAmount = data['Bill Amount'];

//                 setState(() {
//                   billAmountController.text = billAmount;
//                 });
//                 break;
//               }
//             }
//           }
//         }

//         alertBox() {
//           return const AlertDialog(
//             title: Center(
//                 child: Text(
//               'No User Found',
//               style: TextStyle(fontSize: 20, color: Colors.red),
//             )),
//           );
//         }
//       }
//     }
//   }
// }
