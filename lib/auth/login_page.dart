import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/HomeScreen/home_screen.dart';
import 'package:societyuser_app/auth/forgotPassword.dart';
import 'package:societyuser_app/auth/signup_page.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class loginScreen extends StatefulWidget {
  loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController flatNoController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    flatNoController.dispose();
    passwordController.dispose();
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
            const Text(
              "Society",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Manager",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 70,
            ),
            const Text('Welcome Back',
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
                          labelText: 'Flat NO.',
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
                        textInputAction: TextInputAction.done,
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
                            return 'Please enter Password';
                          }
                          return null;
                        },
                      ),
                    ),
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
                          foregroundColor: Color.fromARGB(255, 0, 0, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: const Size(180, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(flatNoController.text,
                                passwordController.text, context);
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return forgotPassword();
                        }));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return signUp();
                        }));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
            SizedBox(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return signUp();
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
    );
  }

  Future<void> login(
      String flatNo, String password, BuildContext context) async {
    try {
      // Fetch the user document from Firestore based on the provided username
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(flatNo)
          .get();

      if (userDoc.exists) {
        // Compare the provided password with the stored password
        final storedPassword = userDoc.data()!['password'];

        if (password == storedPassword) {
          // Login successful
          print('Login successful');
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
          // Navigate to the home screen or perform any other necessary actions
        } else {
          // Incorrect password
          print('Incorrect password');
        }
      } else {
        // User does not exist
        print('User does not exist');
      }
    } catch (e) {
      // Error occurred
      print('Error: $e');
    }
  }
}
