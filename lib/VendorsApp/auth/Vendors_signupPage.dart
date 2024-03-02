import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:societyuser_app/VendorsApp/auth/Vendors_loginPage.dart';

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

  List<String> searchedList = [];
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  String mobile = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = "";
  List<dynamic> tempList = [];
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
            const Text('Register as Vendor',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 12,
                    height: MediaQuery.of(context).size.height * 0.09,
                    padding: const EdgeInsets.all(8),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: companyNameController,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: 'Select Company Name',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder())),
                      suggestionsCallback: (pattern) async {
                        return await getCompanyList(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        companyNameController.text = suggestion.toString();

                        getEmail();
                      },
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.next,
                    controller: mobileController,
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
                          if (_formKey.currentState!.validate()) {
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

  getCompanyList(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('vendorEmployeeList').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

  Future<void> getEmail() async {
    QuerySnapshot EmailList = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(companyNameController.text)
        .collection('employeeList')
        .get();
    tempList = EmailList.docs.map((e) => e.id).toList();
  }

  Future<void> storeUserData(BuildContext context, String mobile, String email,
      String password, String confirmPassword) async {
    for (var i = 0; i < tempList.length; i++) {
      if (tempList[i]
          .toLowerCase()
          .contains(emailController.text.toLowerCase())) {
        emailController.text = tempList[i];
        try {
          // Create a new document in the "users" collection
          await firestore.collection('vendorsLoginDetails').doc(email).set({
            'Mobile No.:': mobile,
            'email': email,
            'password': password,
            'confirmPassword': confirmPassword
          });
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const LoginAsVendors();
            }),
            (route) => false,
          );
          setState(() {
            errorMessage = '';
          });
        } on FirebaseException catch (e) {
          setState(() {
            errorMessage = e.message!;
          });
        }
      }
    }
  }
}
