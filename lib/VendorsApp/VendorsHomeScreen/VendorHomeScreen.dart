import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/serviceRequest/serviceRequestOfFlatNo.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/settings/settings.dart';
import 'package:societyuser_app/VendorsApp/auth/Vendors_loginPage.dart';

// ignore: must_be_immutable
class VendorHomeScreen extends StatefulWidget {
  VendorHomeScreen(
      {super.key,
      this.email,
      this.societyName,
      this.empName,
      this.empDesignation,
      this.empPhone,
      this.companyName});
  String? email;
  String? societyName;
  String? empName;
  String? empDesignation;
  String? empPhone;
  String? companyName;

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

  bool isLoading = false;
  bool isDataAvailable = false;
  String phoneNum = '';
  String currentmonth = DateFormat('MMMM yyyy').format(DateTime.now());
  @override
  void initState() {
    _splashService.getPhoneNum();
    super.initState();
    print(widget.societyName);
  }

  List<String> buttons = ['SERVICE REQUEST', 'SETTINGS'];
  List<Widget Function(String, String, String)> screens = [
    (email, societyName, companyName) => ServiceRequestFlatNo(
          email: email,
          societyName: societyName,
          companyName: companyName,
        ),
    (email, societyName,companyName) => SettingScreen(
          email: email,
          societyName: societyName,
          companyName: companyName,
        ),
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
          actions: [
            IconButton(
                onPressed: () {
                  signOut(context);
                },
                icon: const Icon(
                  Icons.power_settings_new,
                ))
          ]),
      
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
                                      fontSize: 14,
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
                height: 15,
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
                                  backgroundColor: buttonColor,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height *
                                          0.06),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return screens[index](
                                          widget.email!, widget.societyName!, widget.companyName!);
                                    }),
                                  );
                          
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

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    SplashService().removeLogin(context);

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginAsVendors()),
        (route) => false);
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
                  child: Text(
                    'OK',
                    style: TextStyle(color: textColor),
                  )),

            ],
          );
        });
  }
}

