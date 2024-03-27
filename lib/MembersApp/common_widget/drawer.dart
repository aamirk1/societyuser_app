import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/complaint/complaints.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/ledger/member_ladger.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/noc/noc_page.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/notice/circular_notice.dart';
import 'package:societyuser_app/MembersApp/screen/HomeScreen/home_screen.dart';

// ignore: must_be_immutable
class MyDrawer extends StatefulWidget {
  MyDrawer(
      {Key? key,
      required this.flatno,
      required this.username,
      required this.societyName,
      required this.mobile})
      : super(key: key);
  String flatno;
  String username;
  String societyName;
  String mobile;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // ignore: prefer_final_fields, unused_field
  SplashService _splashService = SplashService();

  final TextEditingController flatnoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  String flatno = '';
  File? _image;

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
    flatnoController.text = widget.flatno;
    usernameController.text = widget.username;
    mobileController.text = widget.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, //
                children: [
                  InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: CircleAvatar(
                        radius: 35,
                        child: _image != null
                            ? Image.memory(_image!.readAsBytesSync())
                            : const Icon(Icons.person)),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      widget.username.toString(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      "Flat No. ${widget.flatno}",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      "Mobile No. ${widget.mobile}",
                    ),
                  ),

                  // UserAccountsDrawerHeader(
                  //   accountName: const Text("User Name"),
                  //   accountEmail: const Text("Shashankgreat.com"),
                  //   currentAccountPicture: CircleAvatar(
                  //       backgroundImage:
                  //           _image != null ? FileImage(_image!) : null,
                  //       child:
                  //           _image == null ? const Icon(Icons.person) : null),
                  // ),
                  // ListTile(
                  //   leading: const Icon(Icons.edit),
                  //   title: const Text("Update your profle picture"),
                  //   onTap: _getImage,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Text(
                  //   usernameController.text,
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //   ),
                  // ),
                  //const SizedBox(height: 4),
                  // Text(
                  //   'Flat No.: ${flatnoController.text}',
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //   ),
                  // ),
                  // Text(
                  //   'Mobile No.: ${mobileController.text}',
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Handle Home item tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Member Ladger'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return memberLedger(
                        flatno: widget.flatno,
                        societyName: widget.societyName,
                        username: widget.username);
                  }),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Circular Notice'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return circular_notice(
                        flatno: widget.flatno,
                        societyName: widget.societyName,
                        username: widget.username);
                  }),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) {
                //     return const serviceProvider();
                //   }),
                // );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_repair_service),
              title: const Text('Complaints'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Complaints(
                        flatno: widget.flatno,
                        societyName: widget.societyName,
                        username: widget.username);
                  }),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build_circle_outlined),
              title: const Text('NOC Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return nocPage(
                        flatno: widget.flatno,
                        societyName: widget.societyName,
                        username: widget.username);
                  }),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SplashService().removeLogin(context);

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const loginScreen()),
        (route) => false);
  }
}
