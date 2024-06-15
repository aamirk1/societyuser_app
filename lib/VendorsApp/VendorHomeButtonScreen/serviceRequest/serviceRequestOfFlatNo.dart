// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/serviceRequest/ListOfServiceRequestType.dart';

// ignore: must_be_immutable
class ServiceRequestFlatNo extends StatefulWidget {
  ServiceRequestFlatNo(
      {super.key,
      required this.email,
      required this.societyName,
      required this.companyName});
  String email;
  String societyName;
  String companyName;

  @override
  State<ServiceRequestFlatNo> createState() => _ServiceRequestFlatNoState();
}

class _ServiceRequestFlatNoState extends State<ServiceRequestFlatNo> {
  TextEditingController societyNameController = TextEditingController();

  Map<String, dynamic> vendorDetails = {};
  String companyName = '';
  String societyName = '';
  String empEmail = '';
  String empName = '';
  String empPhone = '';
  List<String> allSociety = [];
  bool isLoading = true;
  String? selectedSocietyName;
  List<dynamic> allFlatNo = [];
  @override
  void initState() {
    super.initState();
    // getCompany(widget.societyName);
    getFlatNo(widget.societyName).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text('All Service Provider'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 12,
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allFlatNo.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                              title: Text(
                                allFlatNo[index],
                                style: TextStyle(color: textColor),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ListOfServiceRequestType(
                                        email: widget.email,
                                        flatNo: allFlatNo[index],
                                        societyName: widget.societyName,
                                      );
                                    },
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                )
              ]),
            ),
    );
  }

  Future getFlatNo(String societyName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('sendComplaintsForVendors')
        .doc(societyName)
        .collection('flatno')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      allFlatNo = querySnapshot.docs.map((e) => e.id).toList();
      setState(() {
        isLoading = false;
      });
    }
    // print('allFlatNo $allFlatNo');
  }

  alertbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: TextStyle(color: textColor),
                    )),
              ],
              title: const Text(
                'Please select a file first!',
                style: TextStyle(color: Colors.red),
              ));
        });
  }
}
