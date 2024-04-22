import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/membersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile({super.key, required this.email});
  String email;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? companyName;
  String vendorName = '';
  String vendorAddress = '';
  String vendorDesignation = '';
  String vendorEmail = '';
  String vendorPhone = '';
  bool isLoading = true;
  @override
  void initState() {
    fetchVendorDetails(widget.email).whenComplete(() async {
      getVendordetails(companyName!).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: appBarBgColor,
        title: const Text('Vendor Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(18.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customRow('Name: ', vendorName),
                  customRow('Company Name: ', companyName!),
                  customRow('Designation: ', vendorDesignation),
                  customRow('Email: ', widget.email),
                  customRow('Phone: ', vendorPhone),
                  customRow('Address: ', vendorAddress),
                ],
              ),
            ),
    );
  }

  Future<void> fetchVendorDetails(String currentEmail) async {
    DocumentSnapshot flatNoQuery = await FirebaseFirestore.instance
        .collection('vendorsLoginDetails')
        .doc(currentEmail)
        .get();

    Map<String, dynamic> vendorDetails =
        flatNoQuery.data() as Map<String, dynamic>;
    companyName = vendorDetails['companyName'];
  }

  Future<void> getVendordetails(String companyName) async {
    await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(companyName)
        .collection('employeeList')
        .doc(widget.email)
        .get()
        .then((value) {
      setState(() {
        vendorName = value.data()!['empName'];
        vendorAddress = value.data()!['empAddress'];
        vendorDesignation = value.data()!['empDesignation'];
        vendorPhone = value.data()!['empPhone'];
      });
    });
  }

  customRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
              ),
            ),
          )
        ],
      ),
    );
  }
}
