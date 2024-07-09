// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/AllGatePassProvider.dart';

// ignore: camel_case_types, must_be_immutable
class ApplyGatePass extends StatefulWidget {
  ApplyGatePass({super.key, this.flatno, this.societyName});
  String? flatno;
  String? societyName;

  @override
  State<ApplyGatePass> createState() => _ApplyGatePassState();
}

// ignore: camel_case_types
class _ApplyGatePassState extends State<ApplyGatePass> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController gatePassTypeController = TextEditingController();
  final TextEditingController controller = TextEditingController();

  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Text(
          'Apply Gate Pass',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
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
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.text,
                            controller: gatePassTypeController,
                            decoration: const InputDecoration(
                                labelText: 'Enter Gate Pass Purpose',
                                border: OutlineInputBorder()),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            keyboardType: TextInputType.multiline,
                            controller: controller,
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
                                    WidgetStateProperty.all(Colors.red)),
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
                                    WidgetStateProperty.all(Colors.green)),
                            onPressed: () async {
                              storeUserData(
                                gatePassTypeController.text,
                                controller.text,
                                currentDate,
                              );
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

  void storeUserData(String gatePassType, String text, String date) async {
    final provider = Provider.of<AllGatePassProvider>(context, listen: false);
    try {
      // Create a new document in the "users" collection
      await firestore
          .collection('gatePassApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('gatePassType')
          .doc(gatePassType)
          .collection('dateOfGatePass')
          .doc(date)
          .set({
        'gatePassType': gatePassType,
        'text': text,
      });
      await firestore
          .collection('gatePassApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('gatePassType')
          .doc(gatePassType)
          .set({"gatePassType": gatePassType});
      await firestore
          .collection('gatePassApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .set({"flatno": widget.flatno});

      provider.addSingleList({
        'gatePassType': gatePassType,
        'text': text,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text('Gate Pass Applied Successfully')),
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
