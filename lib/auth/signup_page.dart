import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/HomeScreen/home_screen.dart';
import 'package:societyuser_app/auth/login_page.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class signUp extends StatefulWidget {
  signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController flatNoController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool validate = false;
  String flatNo = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = "";
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
    flatNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: Container(
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
            // const Text(
            //   "Society",
            //   style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 40,
            //       fontWeight: FontWeight.bold),
            // ),
            // const Text(
            //   "Manager",
            //   style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            const Text('Sign Up',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: flatNoController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          labelText: 'Flat No',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),

                          // enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Flat No';
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
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
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
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
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
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
                    ),
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
                      width: MediaQuery.of(context).size.width * 0.87,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color.fromARGB(255, 0, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: const Size(180, 50),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await storeUserData(
                                context,
                                flatNoController.text,
                                emailController.text,
                                passwordController.text,
                                confirmPasswordController.text);
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 28),
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
                          return loginScreen();
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

  Future<void> storeUserData(BuildContext context, String flatNo, String email,
      String password, String confirmPassword) async {
    try {
      // Create a new document in the "users" collection
      await firestore.collection('users').doc(flatNo).set({
        'Flat No.: ': flatNo,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword
      });
      print('Data stored successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }),
      );
    } on FirebaseException catch (e) {
      print('Error storing data: $e');
    }
  }
}
