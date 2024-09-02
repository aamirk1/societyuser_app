import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/auth/login_page.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
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
  // String userId;

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
  Uint8List? byteData;
  String? fileName;
  String imageUrl = '';
  String imgnames = '';

  @override
  void initState() {
    super.initState();
    flatnoController.text = widget.flatno;
    usernameController.text = widget.username;
    mobileController.text = widget.mobile;
    //getImage();
    displayImage();
    imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        color: const Color.fromARGB(255, 6, 6, 37),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, //
                children: [
                  GestureDetector(
                    onTap: () async {
                      // await pickAndUploadPDF();
                    },
                    child: byteData != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(byteData!),
                            radius: 35,
                            backgroundColor: Colors.grey,
                          )
                        // : CircleAvatar(
                        //     backgroundImage: NetworkImage(imageUrl!),
                        //     radius: 35,
                        //     backgroundColor: Colors.grey,
                        //   )
                        : const CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      widget.username.toString(),
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      "Flat No. ${widget.flatno}",
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    child: Text(
                      "Mobile No. ${widget.mobile}",
                      style: TextStyle(color: buttonTextColor),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: buttonTextColor,
            ),
            ListTile(
              leading: Icon(Icons.home, color: buttonTextColor),
              title: Text(
                'Home',
                style: TextStyle(color: buttonTextColor),
              ),
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
              leading: Icon(Icons.admin_panel_settings_outlined,
                  color: buttonTextColor),
              title: Text(
                'Member Ledger',
                style: TextStyle(color: buttonTextColor),
              ),
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
              leading: Icon(Icons.admin_panel_settings_outlined,
                  color: buttonTextColor),
              title: Text(
                'Circular Notice',
                style: TextStyle(color: buttonTextColor),
              ),
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
              leading: Icon(Icons.settings, color: buttonTextColor),
              title: Text(
                'Settings',
                style: TextStyle(color: buttonTextColor),
              ),
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
              leading: Icon(Icons.home_repair_service, color: buttonTextColor),
              title: Text(
                'Complaints',
                style: TextStyle(color: buttonTextColor),
              ),
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
              leading: Icon(
                Icons.build_circle_outlined,
                color: buttonTextColor,
              ),
              title: Text(
                'NOC Page',
                style: TextStyle(color: buttonTextColor),
              ),
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
              leading: Icon(Icons.logout, color: buttonTextColor),
              title: Text(
                'Logout',
                style: TextStyle(color: buttonTextColor),
              ),
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

  Future<void> getImage() async {
    ListResult listResult = await FirebaseStorage.instance
        .ref('ProfilePictures')
        .child(widget.flatno)
        .listAll();

    if (listResult.items.isNotEmpty) {
      byteData = await listResult.items[0].getData();
      print(byteData);
      //setState(() {});
    }
  }

  // Future<void> pickAndUploadPDF() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['jpg', 'png', 'jpeg'],
  //       allowMultiple: false,
  //       withData: true);

  //   if (result != null) {
  //     byteData = result.files.single.bytes;
  //     fileName = result.files.single.name;
  //     setState(() {});
  //     uploadFile(byteData, fileName!);
  //     print("File Name - $fileName");
  //   } else {
  //     print('File picking canceled');
  //   }
  // }

  void uploadFile(Uint8List? byteData, String fileName) async {
    try {
      if (byteData != null) {
        await FirebaseStorage.instance
            .ref('ProfilePictures')
            .child(widget.flatno)
            .child(fileName)
            .putData(byteData)
            .whenComplete(() async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Image Uploaded!",
              ),
            ),
          );
        });
      } else {
        throw Exception('File bytes are null');
      }
    } catch (e) {
      print('Failed to upload Image: $e');
    }
  }

  void displayImage() async {
    final storage =
        FirebaseStorage.instance.ref('ProfilePictures').child(widget.flatno);

    ListResult result = await storage.list();
    final url = await result.items[0].getData();
    setState(() {
      byteData = url;
    });

    // Uint8List? pdfData = await result.items.first.getData();
    // String imageName = result.items.first.name;
    print('imageName $imageUrl');
  }
}
