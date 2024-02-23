// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/serviceProvider/EmployeeDetails/sendComplaints.dart';

// ignore: camel_case_types, must_be_immutable
class Complaints_List extends StatefulWidget {
  Complaints_List({
    super.key,
    required this.username,
    required this.flatno,
    required this.societyName,
    required this.companyName,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.designation,
  });
  String username;
  String flatno;
  String societyName;
  String companyName;
  String name;
  String email;
  String phone;
  String address;
  String designation;

  @override
  State<Complaints_List> createState() => _Complaints_ListState();
}

// ignore: camel_case_types
class _Complaints_ListState extends State<Complaints_List> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  List<dynamic> allData = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'All Complaints',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shadowColor: Colors.grey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dev Accounts - ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                      Text(
                        'Society Manager App',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.10,
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Member Name: ${widget.username}"),
                            Text("Flat Now.: ${widget.flatno}"),
                            Text("Society Name: ${widget.societyName}"),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.69,
                        child: ListView.builder(
                          itemCount: allData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return ViewGatePass(

                                      //         text:
                                      //             value.sendComplaints[index]
                                      //                 ['text'],
                                      //       );
                                      //     },
                                      //   ),
                                      // );
                                    },
                                    child: Text(
                                      allData[index]['problemsType'].toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SendComplaints(
                flatno: widget.flatno,
                societyName: widget.societyName,
                companyName: widget.companyName,
                name: widget.name,
                email: widget.email,
                phone: widget.phone,
                address: widget.address,
                designation: widget.designation,
              );
            })).whenComplete(() {
              fetchData();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sencomplaintsForVendors')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('vendorCompanyName')
          .doc(widget.companyName)
          .collection('vendorName')
          .doc(widget.name)
          .collection('problemsType')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> tempData =
            querySnapshot.docs.map((e) => e.data()).toList();
        allData = tempData;
      }
      setState(() {});
      isLoading = false;
      // print('sendComplaints: ${allData.length}');
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }
}
