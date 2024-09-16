// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/AllNocProvider.dart';

// ignore: camel_case_types, must_be_immutable
class apply_noc extends StatefulWidget {
  apply_noc({super.key, this.flatno, this.societyName});
  String? flatno;
  String? societyName;

  @override
  State<apply_noc> createState() => _apply_nocState();

  List<String> items = [
    'SALE NOC',
    'GAS NOC',
    'ELECTRIC METER NOC',
    'PASSPORT NOC',
    'RENOVATION NOC',
    'NOC FOR GIFT DEED',
    'BANK',
  ];
  List<String> application = [
    'Sale Noc  Application By Member',
    'Gas Noc Application By Member',
    'Electric Meter Noc Application By Member',
    'Passport Noc Application By Member',
    'Renevation Noc Application By Member',
    'Noc For Gift Deed Application By Member',
    'Bank Application By Member',
  ];
}

// ignore: camel_case_types
class _apply_nocState extends State<apply_noc> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController noctypeController = TextEditingController();
  final TextEditingController saleController = TextEditingController();
  final TextEditingController gasController = TextEditingController();
  final TextEditingController electricController = TextEditingController();
  final TextEditingController passportController = TextEditingController();
  final TextEditingController renovationController = TextEditingController();
  final TextEditingController giftController = TextEditingController();
  final TextEditingController bankController = TextEditingController();

  String date2 = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    saleController.text =
        'I would like to apply for noc to sale my flat ${widget.flatno} to ';
    gasController.text =
        'I would like to apply for noc to gas pipe my flat no ${widget.flatno}  ';
    electricController.text =
        'I would like to apply for noc to change  my electric meter my flat no is ${widget.flatno} ';
    passportController.text =
        'I would like to apply for noc to sale my flat ${widget.flatno}  ';
    renovationController.text =
        'I would like to apply for noc to renovate my flat ${widget.flatno} to ';
    giftController.text =
        'I would like to apply for noc to sale my flat ${widget.flatno} to ';
    bankController.text =
        'I would like to apply for noc to sale my flat ${widget.flatno} to ';
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Text(
          'Apply NOC',
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
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('pending'),
                  //  TypeAheadField(
                  //     textFieldConfiguration: TextFieldConfiguration(
                  //         controller: noctypeController,
                  //         decoration: const InputDecoration(
                  //             labelText: 'Select Noc Type',
                  //             border: OutlineInputBorder())),
                  //     suggestionsCallback: (pattern) async {
                  //       // return await getSocietyList();

                  //       return widget.items;
                  //     },
                  //     itemBuilder: (context, suggestion) {
                  //       return Column(
                  //         children: [
                  //           ListTile(
                  //             title: Text(
                  //               suggestion.toString(),
                  //               style: TextStyle(color: textColor),
                  //             ),
                  //           ),
                  //           Divider(
                  //             color: textColor,
                  //             thickness: 1,
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //     onSuggestionSelected: (suggestion) {
                  //       noctypeController.text = suggestion.toString();
                  //       switch (suggestion.toString()) {
                  //         case 'SALE NOC':
                  //           _showDialog(widget.application[0], saleController);
                  //           break;
                  //         case 'GAS NOC':
                  //           _showDialog(widget.application[1], gasController);
                  //           break;
                  //         case 'ELECTRIC METER NOC':
                  //           _showDialog(
                  //               widget.application[2], electricController);
                  //           break;
                  //         case 'PASSPORT NOC':
                  //           _showDialog(
                  //               widget.application[3], passportController);
                  //           break;
                  //         case 'RENOVATION NOC':
                  //           _showDialog(
                  //               widget.application[4], renovationController);
                  //           break;
                  //         case 'NOC FOR GIFT DEED':
                  //           _showDialog(widget.application[5], giftController);
                  //           break;
                  //         case 'BANK':
                  //           _showDialog(widget.application[6], bankController);
                  //           break;
                  //       }
                  //     }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(String selectedValue, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      selectedValue.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold, //
                          color: textColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: controller,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    maxLines: 6,
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
                                MaterialStateProperty.all(Colors.red)),
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
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () async {
                          storeUserData(
                            noctypeController.text,
                            controller.text,
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
        );
      },
    );
  }

  void storeUserData(
    String nocType,
    String text,
  ) async {
    final provider = Provider.of<AllNocProvider>(context, listen: false);
    try {
      // Create a new document in the "users" collection
      await firestore
          .collection('nocApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofNoc')
          .doc(nocType)
          .collection('dateOfNoc')
          .doc(date2)
          .set({
        'nocType': nocType,
        'text': text,
      });
      await firestore
          .collection('nocApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .set({"flatno": widget.flatno});

      await firestore
          .collection('nocApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofNoc')
          .doc(nocType)
          .set({"typeofNoc": nocType});

      provider.addSingleList({'nocType': nocType});

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('NOC submitted successfully')),
        backgroundColor: Colors.green,
      ));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Error storing data: $e');
    }
  }
}
