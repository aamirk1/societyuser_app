// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';

// ignore: must_be_immutable
class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController flatNoController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController societyNameController = TextEditingController();
  String errorMessage = "";
  List<String> societyNameList = [];
  String? selectedCompanyName;
  String societyName = '';
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 70,
            ),
            const Text('Welcome Back',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            // Center(
            //   child: Container(
            //     color: Colors.white,
            //     height: 40,
            //     width: MediaQuery.of(context).size.width,
            //     child: DropdownButtonHideUnderline(
            //       child: DropdownButton2<String>(
            //         isExpanded: true,
            //         hint: Text(
            //           'Select Society Name',
            //           style: TextStyle(
            //             color: textColor,
            //             fontSize: 14,
            //           ),
            //         ),
            //         items: societyNameList
            //             .map((item) => DropdownMenuItem(
            //                   value: item,
            //                   child: Text(
            //                     item,
            //                     style:
            //                         TextStyle(fontSize: 14, color: textColor),
            //                   ),
            //                 ))
            //             .toList(),
            //         value: selectedCompanyName,
            //         onChanged: (value) {
            //           setState(() {
            //             selectedCompanyName = value;
            //           });
            //           // getEmail(value!);
            //         },
            //         buttonStyleData: const ButtonStyleData(
            //           decoration: BoxDecoration(),
            //           padding: EdgeInsets.symmetric(horizontal: 16),
            //           height: 40,
            //           width: 200,
            //         ),
            //         dropdownStyleData: const DropdownStyleData(
            //           maxHeight: 200,
            //         ),
            //         menuItemStyleData: const MenuItemStyleData(
            //           height: 40,
            //         ),
            //         dropdownSearchData: DropdownSearchData(
            //           searchController: societyNameController,
            //           searchInnerWidgetHeight: 50,
            //           searchInnerWidget: Container(
            //             height: 50,
            //             padding: const EdgeInsets.only(
            //               top: 8,
            //               bottom: 4,
            //               right: 8,
            //               left: 8,
            //             ),
            //             child: TextFormField(
            //               expands: true,
            //               maxLines: null,
            //               controller: societyNameController,
            //               decoration: InputDecoration(
            //                 isDense: true,
            //                 contentPadding: const EdgeInsets.symmetric(
            //                   horizontal: 10,
            //                   vertical: 8,
            //                 ),
            //                 hintText: 'Search society name...',
            //                 hintStyle: const TextStyle(fontSize: 12),
            //                 border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(8),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           searchMatchFn: (item, searchValue) {
            //             return item.value.toString().contains(searchValue);
            //           },
            //         ),
            //         //This to clear the search value when you close the menu
            //         onMenuStateChange: (isOpen) {
            //           if (!isOpen) {
            //             societyNameController.clear();
            //           }
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.next,
                  controller: flatNoController,
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
                      return 'Please enter Mobile No';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
                    labelText: 'New Password',
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
                  onChanged: (value) {
                    validatePassword();
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.done,
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
                    onChanged: (value) {
                      validatePassword();
                    }),
              ),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.87,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 0, 0, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    // minimumSize: const Size(180, 40),
                  ),
                  onPressed: () async {
                    await updateUserData(
                        context,
                        flatNoController.text,
                        passwordController.text,
                        confirmPasswordController.text);
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUserData(BuildContext context, String mobileNo,
      String password, String confirmPassword) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(mobileNo)
          .get();
      // Create a new document in the "users" collection
      if (userDoc.exists) {
        await firestore
            .collection('users')
            .doc(mobileNo)
            .update({'password': password, 'confirmPassword': confirmPassword});
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return const loginScreen();
          }),
        );
      } else {
        SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Mobile number does not exist')));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // ignore: use_build_context_synchronously
    } on FirebaseException {
      // ignore: avoid_print
      // print('Error storing data: $e');
    }
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
}
