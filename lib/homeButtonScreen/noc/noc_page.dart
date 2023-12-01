import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/noc/applyNoc.dart';
import 'package:societyuser_app/homeButtonScreen/noc/nocResponse.dart';

// ignore: camel_case_types, must_be_immutable
class nocPage extends StatefulWidget {
  nocPage({super.key, this.flatno, this.societyName});
  String? flatno;
  String? societyName;

  @override
  State<nocPage> createState() => _nocPageState();
}

// ignore: camel_case_types
class _nocPageState extends State<nocPage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  List<String> nocData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'NOC ',
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
              itemCount: nocData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                        title: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ViewResponse(
                                  
                                );
                              }));
                            },
                            child: Text(
                              nocData[index],
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
            return apply_noc(
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
          .collection('nocApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofNoc')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          nocData.add(doc.id);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }
}
