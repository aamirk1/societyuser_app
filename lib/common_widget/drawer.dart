import 'package:flutter/material.dart';
import 'package:societyuser_app/auth/login_page.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/complaints.dart';
import 'package:societyuser_app/homeButtonScreen/ledger/member_ladger.dart';
import 'package:societyuser_app/homeButtonScreen/noc/noc_page.dart';
import 'package:societyuser_app/homeButtonScreen/notice/circular_notice.dart';
import 'package:societyuser_app/screen/HomeScreen/home_screen.dart';

// ignore: must_be_immutable
class MyDrawer extends StatefulWidget {
  MyDrawer(
      {Key? key,
      required this.flatno,
      required this.username,
      required this.societyName})
      : super(key: key);
  String flatno;
  String username;
  String societyName;
  print(value) => print('flatno: $flatno');
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // ignore: prefer_final_fields, unused_field
  SplashService _splashService = SplashService();

  final TextEditingController flatnoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String flatno = '';

  @override
  void initState() {
    super.initState();
    flatnoController.text = widget.flatno;
    usernameController.text = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      )),
                  Text(
                    'Name: ${usernameController.text}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Flat No.: ${flatnoController.text}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
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
              // Handle Logout item tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const loginScreen();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
