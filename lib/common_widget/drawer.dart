import 'package:flutter/material.dart';
import 'package:societyuser_app/HomeScreen/home_screen.dart';
import 'package:societyuser_app/auth/login_page.dart';
import 'package:societyuser_app/homeButtonScreen/noc_page.dart';
import 'package:societyuser_app/homeButtonScreen/service_provider.dart';
import 'package:societyuser_app/homeButtonScreen/service_request.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
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
                SizedBox(height: 4),
                Text('Flat No.'),
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
            title: const Text('Service Provider'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const serviceProvider();
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
            title: const Text('Service Request'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const serviceRequest();
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
