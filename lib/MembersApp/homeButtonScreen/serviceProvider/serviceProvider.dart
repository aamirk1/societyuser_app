// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/serviceProvider/EmployeeDetails/viewEmployeeDetails.dart';
import 'package:societyuser_app/MembersApp/provider/list_builder_provider.dart';

// ignore: must_be_immutable
class ServiceProvider extends StatefulWidget {
  ServiceProvider({
    super.key,
    required this.flatno,
    required this.societyName,
    required this.username,
  });
  String? email;
  String flatno;
  String societyName;
  String username;

  @override
  State<ServiceProvider> createState() => _ServiceProviderState();
}

class _ServiceProviderState extends State<ServiceProvider> {
  @override
  void initState() {
    super.initState();
    getCompany(widget.societyName).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('All Service Provider'),
        backgroundColor: appBarBgColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<ListBuilderProvider>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.list.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                minVerticalPadding: 0.3,
                                title: Text(
                                  value.list[index]['companyName'],
                                  style: TextStyle(color: textColor),
                                ),
                                leading: Icon(
                                  Icons.account_balance_outlined,
                                  color: buttonColor,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ViewEmployee(
                                        username: widget.username,
                                        society: widget.societyName,
                                        flatno: widget.flatno,
                                        companyName: value.list[index]
                                            ['companyName'],
                                        comEmail: value.list[index]['email'],
                                        comPhone: value.list[index]['phone'],
                                        comAddress: value.list[index]
                                            ['address'],
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
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
