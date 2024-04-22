// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/serviceProvider/ComplaintForvendors/emp_Complaints.dart';
import 'package:societyuser_app/MembersApp/provider/emplist_builder_provider.dart';

// ignore: must_be_immutable
class ViewEmployee extends StatefulWidget {
  ViewEmployee({
    super.key,
    required this.username,
    required this.flatno,
    required this.society,
    required this.companyName,
    required this.comEmail,
    required this.comPhone,
    required this.comAddress,
  });
  String username;
  String flatno;
  String society;
  String companyName;
  String comEmail;
  String comPhone;
  String comAddress;

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  @override
  void initState() {
    super.initState();
    getEmployee(widget.companyName);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Employee in ${widget.companyName}',
          style: TextStyle(color: buttonTextColor),
        ),
        backgroundColor: appBarBgColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<EmpListBuilderProvider>(builder: (context, value, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: value.empList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: Icon(
                            Icons.person_3_rounded,
                            color: textColor,
                          ),
                          title: Text(
                            value.empList[index]['empName'],
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Text(
                            value.empList[index]['empDesignation'],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return Complaints_List(
                                  username: widget.username,
                                  societyName: widget.society,
                                  flatno: widget.flatno,
                                  companyName: widget.companyName,
                                  name: value.empList[index]['empName'],
                                  email: value.empList[index]['empEmail'],
                                  address: value.empList[index]['empAddress'],
                                  phone: value.empList[index]['empPhone'],
                                  designation: value.empList[index]
                                      ['empDesignation'],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }

  Future<void> getEmployee(String companyName) async {
    final provider =
        Provider.of<EmpListBuilderProvider>(context, listen: false);
    provider.empList.clear();

    QuerySnapshot companyQuerySnapshot = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(companyName)
        .collection('employeeList')
        .get();

    List<dynamic> allCompany =
        companyQuerySnapshot.docs.map((e) => e.data()).toList();
    provider.setBuilderEmpList(allCompany);
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
            'No data found!',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}
