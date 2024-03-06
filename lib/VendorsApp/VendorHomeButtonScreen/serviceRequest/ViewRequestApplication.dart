import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewRequestApplication extends StatefulWidget {
  ViewRequestApplication(
      {super.key,
      required this.email,
      required this.flatNo,
      required this.companyName,
      required this.vendorName,
      required this.societyName,
      required this.requestType});

  String email;
  String flatNo;
  String societyName;
  dynamic requestType;
  String companyName;
  String vendorName;

  @override
  State<ViewRequestApplication> createState() => _ViewRequestApplicationState();
}

class _ViewRequestApplicationState extends State<ViewRequestApplication> {
  bool isLoading = true;
  Map<String, dynamic> allData = {};

  @override
  void initState() {
    getAllData().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    allData['problemsType'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    allData['text'],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                Colors.green,
                              )),
                              onPressed: () {},
                              child: const Text('Complete'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 255, 189, 7),
                              )),
                              onPressed: () {},
                              child: const Text('Processing'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getAllData() async {
    DocumentSnapshot requestTypeQuery = await FirebaseFirestore.instance
        .collection('sendComplaintsForVendors')
        .doc(widget.societyName)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('vendorCompanyName')
        .doc(widget.companyName)
        .collection('vendorName')
        .doc(widget.vendorName)
        .collection('problemsType')
        .doc(widget.requestType)
        .get();

    allData = requestTypeQuery.data() as Map<String, dynamic>;
  }
}
