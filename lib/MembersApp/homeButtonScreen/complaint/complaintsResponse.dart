// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/provider/AllComplaintProvider.dart';
import 'package:societyuser_app/membersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class ViewComplaints extends StatefulWidget {
  ViewComplaints({
    super.key,
    this.complaintsType,
    this.flatNo,
    this.society,
    required this.date,
  });
  String date;
  String? society;
  String? flatNo;
  String? complaintsType;
  @override
  State<ViewComplaints> createState() => _ViewComplaintsState();
}

class _ViewComplaintsState extends State<ViewComplaints> {
  Map<String, dynamic> complaintData = {};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData(widget.complaintsType!).whenComplete(() => setState(() {
          isLoading = false;
        }));
    // getTypeOfNoc(widget.society, widget.flatNo, widget.nocType,widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.98,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.complaintsType!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: textColor),
                                  ),
                                  Text(
                                    complaintData['text'] ?? 'No Text Given',
                                    style: TextStyle(
                                        fontSize: 12, color: textColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Center(
                                      child: Text(
                                          "Response: ${complaintData['response'] ?? 'No Response Given'}",
                                          style: TextStyle(
                                              color: textColor, fontSize: 15)),
                                    )),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> fetchData(String complaintsType) async {
    final provider = Provider.of<AllComplaintProvider>(context, listen: false);
    provider.setBuilderList([]);
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.society)
          .collection('flatno')
          .doc(widget.flatNo)
          .collection('typeofcomplaints')
          .doc(complaintsType)
          .collection('dateOfComplaint')
          .doc(widget.date)
          .get();
      if (querySnapshot.data() != null) {
        Map<String, dynamic> tempData =
            querySnapshot.data() as Map<String, dynamic>;
        complaintData = tempData;
      }
    } catch (e) {
      // ignore: avoid_print
      // print('Error fetching data: $e');
    }
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
      },
    );
  }
}
