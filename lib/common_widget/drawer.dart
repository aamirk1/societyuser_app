import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/auth/login_page.dart';
import 'package:societyuser_app/auth/splash_service.dart';
import 'package:societyuser_app/homeButtonScreen/notice/circular_notice.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/complaints.dart';
import 'package:societyuser_app/homeButtonScreen/ladger/member_ladger.dart';
import 'package:societyuser_app/homeButtonScreen/noc/noc_page.dart';
import 'package:societyuser_app/screen/HomeScreen/home_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  SplashService _splashService = SplashService();

  final TextEditingController _societyNameController = TextEditingController();

  final TextEditingController flatnoController = TextEditingController();
  String flatno = '';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    )),
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Flat No.: ${flatnoController.text}'),
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
                  return memberLadger();
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
                  return const circular_notice();
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
                  return const complaints();
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
                  return const nocPage();
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
                  return loginScreen();
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> getMemberFlat() async {
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
          .doc(flatno)
          .get();

      Map<String, dynamic> tempData =
          dataDocumentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> dataList = tempData['data'];

      for (var data in dataList) {
        if (phoneNum == data['Mobile No.']) {
          flatno = data['Flat No.'];
          print(flatno);
          setState(() {
            flatnoController.text = flatno;
          });
          break;
        }
      }
    }
  }
}
