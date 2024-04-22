// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/list_builder_provider.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/serviceRequest/ListOfServiceRequestType.dart';

// ignore: must_be_immutable
class ServiceRequestFlatNo extends StatefulWidget {
  ServiceRequestFlatNo(
      {super.key, required this.email, required this.societyName});
  String email;
  String societyName;

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
    getSocietyName().whenComplete(() async {
      await fetchVendorDetails(widget.email);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    // getCompany(widget.societyName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text('All Service Provider'),
      ),
      body: SingleChildScrollView(
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

  Future<void> fetchVendorDetails(String currentEmail) async {
    DocumentSnapshot flatNoQuery = await FirebaseFirestore.instance
        .collection('vendorsLoginDetails')
        .doc(currentEmail)
        .get();
    vendorDetails = flatNoQuery.data() as Map<String, dynamic>;
    companyName = vendorDetails['companyName'];
    societyName = vendorDetails['society'];
    empEmail = vendorDetails['empEmail'];
    empName = vendorDetails['empName'];
    empPhone = vendorDetails['empPhone'];
  }

  Future<List<String>> getSocietyName() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();

    allSociety = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    return allSociety;
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
