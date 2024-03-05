import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/others/others.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/serviceRequest/serviceRequestOfFlatNo.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/settings/settings.dart';

// ignore: must_be_immutable
class VendorHomeScreen extends StatefulWidget {
  String? email;
  VendorHomeScreen({super.key, this.email});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

bool isSocietySelected = false;

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final SplashService _splashService = SplashService();
  final TextEditingController societyNameController = TextEditingController();
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

  List<String> buttons = ['SERVICE REQUEST', 'SETTINGS', 'OTHERS'];
  List<
      Widget Function(
        String,
      )> screens = [
    (email) => ServiceRequestFlatNo(
          email: email,
        ),
    (email) => SettingScreen(
          email: email,
        ),
    (email) => const Others(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Society Vendor App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // drawer: MyDrawer(
      //     flatno: flatno,
      //     username: name,
      //     societyName: _societyNameController.text,
      //     mobile: mobile),
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

                // height: 20,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
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
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height *
                                          0.06),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          screens[index](widget.email!),
                                    ),
                                  );
                                  // if (isSocietySelected) {

                                  //   );
                                  // } else {
                                  //   customDialogBox();
                                  // }
                                },
                                child: Text(buttons[index])),
                          );
                        })),
              ]),
            ],
          ),
        ),
      ),
    );
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
