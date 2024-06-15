import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:societyuser_app/VendorsApp/auth/Vendors_loginPage.dart';
import 'package:societyuser_app/membersApp/common_widget/colors.dart';

// ignore: camel_case_types
class RegisterAsVendors extends StatefulWidget {
  const RegisterAsVendors({super.key});

  @override
  State<RegisterAsVendors> createState() => _RegisterAsVendorsState();
}

// ignore: camel_case_types
class _RegisterAsVendorsState extends State<RegisterAsVendors> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  List<String> companyNameList = [];
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  String mobile = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = "";
  List<dynamic> tempList = [];
  List<dynamic> emailList = [];
  String societyName = '';
  bool isLoading = true;
  String? selectedCompanyName;
  void validatePassword() {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match";
      });
    } else {
      setState(() {
        errorMessage = '';
      });
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getCompanyList().whenComplete(() {
      getEmail(selectedCompanyName!).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const MyDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Society Manager",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                "Society Information & Management System",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Register as Vendor',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Company Name',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        items: companyNameList
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontSize: 14, color: textColor),
                                  ),
                                ))
                            .toList(),
                        value: selectedCompanyName,
                        onChanged: (value) {
                          setState(() {
                            selectedCompanyName = value;
                          });
                          getEmail(value!);
                        },
                        buttonStyleData: const ButtonStyleData(
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 200,
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: companyNameController,
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
                              controller: companyNameController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search company name...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().contains(searchValue);
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            companyNameController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    controller: mobileController,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                      labelText: 'Mobile No.',

                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),

                      // enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Mobile No.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      // enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      // enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                      _formKey.currentState?.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      // enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value != password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                      _formKey.currentState?.validate();
                    },
                  ),
                  Text(
                    errorMessage,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(255, 0, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              selectedCompanyName != null) {
                            await storeUserData(
                                context,
                                mobileController.text,
                                emailController.text,
                                passwordController.text,
                                confirmPasswordController.text);
                          }
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginAsVendors();
                        }));
                      },
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
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

  Future<List<String>> getCompanyList() async {
    companyNameList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('vendorEmployeeList').get();

    companyNameList = querySnapshot.docs.map((e) => e.id).toList();

    return companyNameList;
  }

  Future<void> getEmail(String companyName) async {
    QuerySnapshot emailLists = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(companyName)
        .collection('employeeList')
        .get();
    emailList = emailLists.docs.map((e) => e.id).toList();

    // getSocietyList(companyName, email);
  }

  Future<void> getSocietyList(String companyName, String email) async {
    DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(companyName)
        .collection('employeeList')
        .doc(email)
        .get();
    societyName = societyQuerySnapshot['society'];
    // print('societyList: $societyName');
  }

  Future<void> storeUserData(BuildContext context, String mobile, String email,
      String password, String confirmPassword) async {
    for (var i = 0; i < emailList.length; i++) {
      if (emailList[i]
          .toLowerCase()
          .contains(emailController.text.toLowerCase())) {
        email = emailList[i];
        getSocietyList(selectedCompanyName!, email).whenComplete(() async {
          try {
            storeCompanyInSharedPref(selectedCompanyName!,societyName);
            // Create a new document in the "users" collection
            await firestore.collection('vendorsLoginDetails').doc(email).set({
              "companyName": selectedCompanyName,
              'Mobile No.': mobile,
              'email': email,
              'society': societyName,
              'password': password,
              'confirmPassword': confirmPassword
            });
            SnackBar snackBar = const SnackBar(
              backgroundColor: Colors.yellow,
              content: Center(child: Text('Email does not exist')),
            );
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return const LoginAsVendors();
              }),
              (route) => false,
            );
          } on FirebaseException catch (e) {
            setState(() {
              errorMessage = e.message!;
            });
          }
        });
      } else {
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.yellow,
          content: Center(child: Text('Email does not exist')),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void storeCompanyInSharedPref(String companyName, String societyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("companyName", companyName);
  }
}
