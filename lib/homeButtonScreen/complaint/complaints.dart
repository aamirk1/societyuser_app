import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/applyComplaint.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/complaintsResponse.dart';

// ignore: camel_case_types, must_be_immutable
class Complaints extends StatefulWidget {
  Complaints({super.key, this.flatno, this.societyName});
  String? flatno;
  String? societyName;

  @override
  State<Complaints> createState() => _ComplaintsState();
}

// ignore: camel_case_types
class _ComplaintsState extends State<Complaints> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  List<String> complaintsData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Complaints ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // drawer: const MyDrawer(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Card(
            elevation: 5,
            shadowColor: Colors.grey,
            // margin: EdgeInsets.all(2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListView.builder(
              itemCount: complaintsData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                        title: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ViewComplaintsResponse();
                              }));
                            },
                            child: Text(
                              complaintsData[index],
                              style: const TextStyle(color: Colors.black),
                            ))),
                    const Divider(
                      color: Colors.grey,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ApplyComplaints(
              flatno: widget.flatno,
              societyName: widget.societyName,
            );
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofcomplaints')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          complaintsData.add(doc.id);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }
}
