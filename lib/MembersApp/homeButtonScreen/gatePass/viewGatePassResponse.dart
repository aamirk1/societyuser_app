// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class ViewGatePass extends StatefulWidget {
  ViewGatePass({
    super.key,
    required this.gatePassType,
    required this.societyName,
    required this.flatNo,
    // required this.text,
  });
  String gatePassType;
  String societyName;
  String flatNo;
  // String text;
  @override
  State<ViewGatePass> createState() => _ViewGatePassState();
}

class _ViewGatePassState extends State<ViewGatePass> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  Map<String, dynamic> checkResult = {};

  List<String> fileList = [];
  @override
  void initState() {
    super.initState();
    getGatePass(widget.societyName, widget.flatNo, widget.gatePassType)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'View Gate Pass',
          style: TextStyle(color: buttonTextColor),
        ),
        backgroundColor: appBarBgColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        widget.gatePassType,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                    const SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 5.0),
                              child: Text(
                                ' widget.text',
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: textColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        checkResult['isApproved'] == true
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green[800],
                                ),
                                height: 40,
                                width: 90,
                                child: const Center(
                                  child: Text(
                                    'Approved',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            : checkResult['isRejected'] == true
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red[800],
                                    ),
                                    height: 40,
                                    width: 90,
                                    child: const Center(
                                      child: Text(
                                        'Rejected',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.yellow[800],
                                    ),
                                    height: 40,
                                    width: 90,
                                    child: const Center(
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
    );
  }

  Future<void> getGatePass(
      String selectedSociety, String flatNo, String gatePassType) async {
    DocumentSnapshot gatepass = await FirebaseFirestore.instance
        .collection('gatePassApplications')
        .doc(selectedSociety)
        .collection('flatno')
        .doc(flatNo)
        .collection('gatePassType')
        .doc(gatePassType)
        .get();

    checkResult = gatepass.data() as Map<String, dynamic>;
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
              'Application in progress',
              style: TextStyle(color: Colors.red),
            ),
          );
        });
  }
}
