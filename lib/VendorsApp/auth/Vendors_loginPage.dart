import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';
import 'package:societyuser_app/VendorsApp/VendorsHomeScreen/VendorHomeScreen.dart';
import 'package:societyuser_app/VendorsApp/auth/Vendors_signupPage.dart';

// ignore: camel_case_types
class LoginAsVendors extends StatefulWidget {
  const LoginAsVendors({super.key});

  @override
  State<LoginAsVendors> createState() => _LoginAsVendorsState();
}

// ignore: camel_case_types
class _LoginAsVendorsState extends State<LoginAsVendors> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userFlatNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String companyName = '';
  String societyName = '';
  String empName = '';
  String empDesignation = '';
  String empPhone = '';
  String empEmail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const MyDrawer(flatnumber: userFlatNumber),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(15),
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
          const  SizedBox(
              height: 5,
            ),
            const Center(
              child: Text(
                "Society Information & Management System",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
       const     SizedBox(
              height: 5,
            ),
            const Text('Login as Vendor',
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
                        return 'Please enter Email Id';
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
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(emailController.text, passwordController.text,
                                context);
                          }
                        },
                        child: const Text(
                          'Login as Vendors',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) {
                //         return const forgotPassword();
                //       }));
                //     },
                //     child: const Text(
                //       "Forgot Password?",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const loginScreen();
                      }),
                    );
                  },
                  child: const Text(
                    "Login as Members",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const RegisterAsVendors();
                      }),
                    );
                  },
                  child: const Text(
                    "Register as Vendors",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    fetchVendorDetails(email);
    try {
      // Fetch the user document from Firestore based on the provided username
      final userDoc = await FirebaseFirestore.instance
          .collection('vendorsLoginDetails')
          .doc(email)
          .get();

      if (userDoc.exists) {
        // Compare the provided password with the stored password
        final storedPassword = userDoc.data()!['password'];

        if (password == storedPassword) {
          SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text('Login successful')),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          fetchVendorDetails(email);
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => VendorHomeScreen(
                        email: email,
                        societyName: societyName,
                        empDesignation: empDesignation,
                        empName: empName,
                        empPhone: empPhone,
                        companyName: companyName,
                      )),
              (route) => false);
        } else {
          // Incorrect password
          SnackBar snackBar = const SnackBar(
            backgroundColor: Colors.red,
            content: Center(child: Text('Incorrect password')),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // print('Incorrect password');
        }
      } else {
        // User does not exist
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Center(child: Text('User does not exist'))),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // print('User does not exist');
      }
    } catch (e) {
      // Error occurred
      // ignore: avoid_print
      // print('Error: $e');
    }
  }

  Future<void> fetchVendorDetails(String currentEmail) async {
    DocumentSnapshot flatNoQuery = await FirebaseFirestore.instance
        .collection('vendorsLoginDetails')
        .doc(currentEmail)
        .get();

    Map<String, dynamic> vendorDetails = {};
    vendorDetails = flatNoQuery.data() as Map<String, dynamic>;

    // print('vendorDetails: $vendorDetails');

    companyName = vendorDetails['companyName'];
    societyName = vendorDetails['society'];
    empEmail = vendorDetails['empEmail'];
    empName = vendorDetails['empName'];
    empPhone = vendorDetails['empPhone'];
  
    storeCompanyInSharedPref(
      companyName,
      societyName,
      empEmail,
      empName,
      empPhone,
    );

    // print('storedCompanyName: $storeCompanyInSharedPref');
  }

  void storeCompanyInSharedPref(String companyName, String societyName,
      String empEmail, String empName, String empPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "companyName",
      companyName,
    );
    await prefs.setString(
      "societyName",
      societyName,
    );
    await prefs.setString(
      "empEmail",
      empEmail,
    );
    await prefs.setString(
      "empName",
      empName,
    );
    await prefs.setString(
      "empPhone",
      empPhone,
    );
  }
}
