import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/complaint/complaints.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/gatePass/gatePass.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/member_ladger.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/noc/noc_page.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/notice/circular_notice.dart';
import 'package:societyuser_app/MembersApp/provider/AllNoticeProvider.dart';
import 'package:societyuser_app/MembersApp/provider/ChangeValueProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isSocietySelected = false;
bool isflatnoSelected = false;
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
  final TextEditingController payableAmountController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController flatnoController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // final TextEditingController _controllerSociety = TextEditingController();

  // Boolean value fro updating and setting user role in database
  bool userExist = false;
  List<String> societyList = [];
  List<String> flatNOList = [];
  List<dynamic> memberList = [];
  List<dynamic> allNotice = [];
  String? selectedSocietyName;
  String? selectedFlatNo;
  String name = '';
  String username = '';
  String status = '';
  String billAmount = '';
  String payableAmount = '';
  String mobile = '';
  String totalNotice = '2';
  bool isLoading = true;
  bool isDataAvailable = false;
  String phoneNum = '';
  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String lastMonth = DateFormat('MMMM yyyy').format(
    DateTime.now().subtract(const Duration(days: 30)),
  );
  @override
  void initState() {
    _splashService.getPhoneNum();
    getSocietyList().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  List<String> buttons = [
    'MEMBER LEDGER',
    'CIRCULAR/NOTICE',
    'NOC MANAGEMENT',
    'GRIEVANCE / COMPLAINT',
    // 'RESIDENT MANAGEMENT',
    // 'SERVICE PROVIDER MANAGEMENT',
    'GATE PASS',
    // 'REPORTS',
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
    // (flatno, society, name) => ServiceProvider(
    //       flatno: flatno,
    //       societyName: society,
    //       username: name,
    //     ),
    (flatno, society, name) => GatePass(
          flatno: flatno,
          societyName: society,
          username: name,
        ),
    // (flat, society, username) => const ReportScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBgColor,
          title: const Center(
            child: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
            )
          ],
        ),
        // drawer: MyDrawer(
        //     flatno: selectedFlatNo ?? '',
        //     username: name,
        //     societyName: selectedSocietyName ?? '',
        //     mobile: mobile),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<ChangeValue>(builder: (context, value, child) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.40,

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
                                            ' Society Manager',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.purple),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Select Society',
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                          items: societyList
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: textColor),
                                                    ),
                                                  ))
                                              .toList(),
                                          // value: selectedSocietyName,
                                          onChanged: (value) async {
                                            flatNOList.clear();
                                            flatnoController.clear();
                                            selectedFlatNo = '';
                                            selectedSocietyName = value;
                                            await getflatno(
                                                    selectedSocietyName!)
                                                .whenComplete(() {
                                              getNotice(selectedSocietyName);
                                            });
                                            setState(() {});
                                          },
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                border: Border(
                                                    right: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                    left: BorderSide(
                                                        color: Colors.grey),
                                                    top: BorderSide(
                                                        color: Colors.grey),
                                                    bottom: BorderSide(
                                                      color: Colors.grey,
                                                    ))),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            searchController:
                                                _societyNameController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller:
                                                    _societyNameController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'Search society',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value
                                                  .toString()
                                                  .contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              _societyNameController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Select Flat',
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                          items: flatNOList
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: textColor),
                                                    ),
                                                  ))
                                              .toList(),
                                          // value: selectedSocietyName,
                                          onChanged: (value) {
                                            isflatnoSelected = false;
                                            selectedFlatNo = value;
                                            getMemberName(selectedSocietyName!,
                                                    value!)
                                                .whenComplete(() {
                                              isflatnoSelected = true;
                                              _loadData();
                                            });
                                          },
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border(
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                                left: BorderSide(
                                                    color: Colors.grey),
                                                top: BorderSide(
                                                    color: Colors.grey),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            searchController: flatnoController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: flatnoController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'Search flat',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value
                                                  .toString()
                                                  .contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              flatnoController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 40.0),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              buildInfoRow(
                                                  context,
                                                  Icons.person,
                                                  "Member Name",
                                                  usernameController.text),
                                              buildInfoRow(
                                                  context,
                                                  Icons.home,
                                                  "Society Name",
                                                  selectedSocietyName ?? ''),
                                              buildInfoRow(
                                                  context,
                                                  Icons.home,
                                                  "Flat No.",
                                                  selectedFlatNo ?? ''),
                                            ]),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.99, //add width and container on 270324
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: DataTable(
                                    columnSpacing: 155,
                                    columns: [
                                      const DataColumn(
                                          label: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Dues',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      DataColumn(
                                          label: value
                                                  .grandTotalBillAmount.isEmpty
                                              ? const Text('Rs: 0')
                                              : Text(
                                                  'Rs: ${value.grandTotalBillAmount}')),
                                    ],
                                    dividerThickness: 2,
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(),
                                              backgroundColor: buttonColor,
                                            ),
                                            onPressed: () {
                                              if (isflatnoSelected) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return memberLedger(
                                                      flatno: selectedFlatNo!,
                                                      societyName:
                                                          selectedSocietyName!,
                                                      username:
                                                          usernameController
                                                              .text,
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
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        DataCell(ElevatedButton(
                                          style: ButtonStyle(
                                              shape: WidgetStateProperty.all(
                                                const RoundedRectangleBorder(),
                                              ),
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      buttonColor)),
                                          onPressed: () {},
                                          child: const Text(
                                            'Pay',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: GridView.builder(
                                  itemCount: buttons.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          // mainAxisSpacing: 2.0,
                                          crossAxisSpacing: 10.0,
                                          childAspectRatio: 0.7,
                                          crossAxisCount: 3),
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      TextButton(
                                          onPressed: () {
                                            if (isflatnoSelected) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      screens[index](
                                                          selectedFlatNo!,
                                                          selectedSocietyName!,
                                                          usernameController
                                                              .text),
                                                ),
                                              );
                                            } else {
                                              customDialogBox();
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Card(
                                                    elevation: 10,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: getIcon(
                                                          buttons[index]),
                                                    ),
                                                  ),
                                                  buttons[index] ==
                                                          "CIRCULAR/NOTICE"
                                                      ? Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Colors.red,
                                                            child: Text(
                                                              totalNotice,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                            ),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                buttons[index],
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 10),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                    ]);
                                  }),
                            ),
                          ]),
                    ],
                  ),
                );
              }));
  }

  Widget getIcon(String iconName) {
    switch (iconName) {
      case "MEMBER LEDGER":
        return const Icon(
          Icons.receipt_long_rounded,
          size: 30,
        );
      case "CIRCULAR/NOTICE":
        return const Icon(
          Icons.messenger_outline_rounded,
          size: 30,
        );
      case "NOC MANAGEMENT":
        return const Icon(
          Icons.manage_search_sharp,
          size: 30,
        );
      case "GRIEVANCE / COMPLAINT":
        return const Icon(
          Icons.my_library_books_outlined,
          size: 30,
        );
      case "SERVICE PROVIDER MANAGEMENT":
        return const Icon(
          Icons.home_repair_service_outlined,
          size: 30,
        );
      case "GATE PASS":
        return const Icon(
          Icons.sensor_door_outlined,
          size: 35,
        );

      default:
        return const Icon(
          Icons.construction_rounded,
          size: 30,
        );
    }
  }

  Future<List<String>> getSocietyList() async {
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
        if (phoneNum == data['Mobile No.'].toString()) {
          isUserPresent = true;
          break;
        }
      }
      if (isUserPresent) {
        temp.add(allSociety[i]);
      }
    }
    societyList = temp.map((e) => e.toString()).toList();
    if (societyList.isEmpty) {
      societyList.add(['No Data Found'].toString());
    }
    return societyList;
  }

  Future<void> getflatno(String selectedSociety) async {
    String phoneNum = '';

    phoneNum = await _splashService.getPhoneNum();
    DocumentSnapshot societyDocumentSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(selectedSociety)
        .get();
    if (societyDocumentSnapshot.exists) {
      Map<String, dynamic> tempData =
          societyDocumentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> dataList = tempData['data'];
      for (var data in dataList) {
        if (data['Mobile No.'].toString() == phoneNum) {
          flatNOList.add(data['Flat No.'].toString());
        }
      }
    }
  }

  Future<void> getMemberName(
      String selectedSociety, String selectedFlatno) async {
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
          if (phoneNum == data['Mobile No.'].toString() &&
              selectedFlatno == data['Flat No.'].toString()) {
            {
              name = data['Member Name'];
              status = data['Status'] ?? 'Not Available';
              mobile = data['Mobile No.'].toString();

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
  }

  void customDialogBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Select Flat No. First',
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: textColor),
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

  Future<void> getNotice(String? selectedSociety) async {
    final provider = Provider.of<AllNoticeProvider>(context, listen: false);

    QuerySnapshot getallNotice = await FirebaseFirestore.instance
        .collection('notice')
        .doc(selectedSociety)
        .collection('notices')
        .get();
    List<dynamic> allTypeOfNotice =
        getallNotice.docs.map((e) => e.data()).toList();
    allNotice = allTypeOfNotice;
    totalNotice = allNotice.length.toString();
    provider.setBuilderNoticeList(allTypeOfNotice);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    SplashService().removeLogin(context);

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const loginScreen(),
        ),
        (route) => false);
  }

  Future<void> _loadData() async {
    // Access the DataProvider and call fetchData
    await Provider.of<ChangeValue>(context, listen: false).fetchData(
        selectedSocietyName!, selectedFlatNo!, usernameController.text);
  }
}
