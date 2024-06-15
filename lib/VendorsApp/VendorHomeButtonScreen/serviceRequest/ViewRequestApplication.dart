import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/membersApp/common_widget/colors.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _hasCallSupport = false;
  @override
  void initState() {
    getAllData().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
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
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin:  const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.78,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  allData['problemsType'],
                                  style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  allData['text'],
                                  style:  TextStyle(
                                    fontSize: 12,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            'Member No.: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: textColor),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.green,
                              ),
                            ),
                            onPressed: _hasCallSupport
                                ? () => setState(() {
                                      _makePhoneCall(allData['phone']);
                                    })
                                : null,
                            child: _hasCallSupport
                                ? Text(allData['phone'])
                                : const Text('Calling not supported'),
                          ),
                        ],
                      ),
                      
                    ],
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
