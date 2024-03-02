// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/list_builder_provider.dart';

// ignore: must_be_immutable
class ServiceRequest extends StatefulWidget {
  ServiceRequest(
      {super.key,
      required this.flatno,
      required this.societyName,
      required this.username});
  String flatno;
  String societyName;
  String username;

  @override
  State<ServiceRequest> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  @override
  void initState() {
    super.initState();
    // getCompany(widget.societyName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service Provider'),
        backgroundColor: appBarBgColor,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.deepPurple
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ,
        //   ],
        // ),
      )
    );
  }

  Future<void> getCompany(String selectedSociety) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);

    QuerySnapshot companyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorList')
        .doc(selectedSociety)
        .collection('companyList')
        .get();

    List<dynamic> allCompany =
        companyQuerySnapshot.docs.map((e) => e.data()).toList();

    provider.setBuilderList(allCompany);
  }

  Future<void> deleteEmp(
      String selectedSociety, String company, int index) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);
    DocumentReference deleteEmployee = FirebaseFirestore.instance
        .collection('vendorList')
        .doc(selectedSociety)
        .collection('companyList')
        .doc(company);

    await deleteEmployee.delete();

    provider.removeData(index);
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
