// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

class SendComplaints extends StatefulWidget {
  const SendComplaints(
      {super.key,
      required this.societyName,
      required this.flatno,
      required this.companyName,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.designation,
      this.callback});
  final Function()? callback;
  final String societyName;
  final String flatno;
  final String companyName;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String designation;

  @override
  State<SendComplaints> createState() => _SendComplaintsState();
}

class _SendComplaintsState extends State<SendComplaints> {
  TextEditingController textController = TextEditingController();
  bool isLoading = false;
  TextEditingController problemsType = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send Complaints to ${widget.name}',
          style: TextStyle(color: buttonTextColor),
        ),
        backgroundColor: buttonColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                TextField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.multiline,
                                  controller: problemsType,
                                  decoration: const InputDecoration(
                                      hintText: "Issue Type",
                                      border: OutlineInputBorder()),
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.multiline,
                                  controller: textController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                  maxLines: 6,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () async {
                                    storeUserData(
                                        textController.text, problemsType.text);
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void storeUserData(String text, String problemsType) async {
    try {
      // Create a new document in the "users" collection

      await firestore
          .collection('sendComplaintsForVendors')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('vendorCompanyName')
          .doc(widget.companyName)
          .collection('vendorName')
          .doc(widget.name)
          .collection('problemsType')
          .doc(problemsType)
          .set({
        'text': text,
        'phone': widget.phone,
        'flatno': widget.flatno,
        'vendorCompanyName': widget.companyName,
        'vendorName': widget.name,
        'problemsType': problemsType
      });
      await firestore
          .collection('sendComplaintsForVendors')
          .doc(widget.societyName)
          .set({
        "societyName": widget.societyName,
      });

      await firestore
          .collection('sendComplaintsForVendors')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .set({
        "flatno": widget.flatno,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Complaint Sent'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Error storing data: $e');
    }
  }
}
