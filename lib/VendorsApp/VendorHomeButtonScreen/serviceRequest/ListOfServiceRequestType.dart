import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/serviceRequest/ViewRequestApplication.dart';
import 'package:societyuser_app/membersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class ListOfServiceRequestType extends StatefulWidget {
  ListOfServiceRequestType(
      {super.key,
      required this.email,
      required this.flatNo,
      required this.societyName});
  String email;
  String flatNo;
  String societyName;

  @override
  State<ListOfServiceRequestType> createState() =>
      _ListOfServiceRequestTypeState();
}

class _ListOfServiceRequestTypeState extends State<ListOfServiceRequestType> {
  List<dynamic> allRequestType = [];
  List<dynamic> allRequest = [];
  String? companyName;
  String? vendorName;
  bool isLoading = true;
  @override
  void initState() {
    getCompanyName().whenComplete(() async {
      await getRequestType();
      // print(widget.societyName);
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarBgColor,
          title: const Text(
            'All Type of Service Request',
          )),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 12,
                    height: MediaQuery.of(context).size.height * 0.99,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allRequest.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: ListTile(
                              title: Text(
                                allRequest[index],
                                style: TextStyle(color: textColor),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ViewRequestApplication(
                                        email: widget.email,
                                        flatNo: widget.flatNo,
                                        companyName: companyName!,
                                        vendorName: vendorName!,
                                        societyName: widget.societyName,
                                        requestType:
                                            allRequest[index].toString(),
                                      );
                                    },
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                )
              ]),
            ),
    );
  }

  Future getCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyName = prefs.getString('companyName');
    await getVendordetails(companyName);
  }

  getVendordetails(String? companyName) async {
    DocumentSnapshot vendorQuery = await FirebaseFirestore.instance
        .collection('vendorEmployeeList')
        .doc(companyName)
        .collection('employeeList')
        .doc(widget.email)
        .get();
    // vendorName = vendorQuery.exists ? vendorQuery['name'] : 'No name found';

    vendorName = vendorQuery['empName'];
  }

  Future<void> getRequestType() async {
    QuerySnapshot requestTypeQuery = await FirebaseFirestore.instance
        .collection('sendComplaintsForVendors')
        .doc(widget.societyName)
        .collection('flatno')
        .doc(widget.flatNo)
        .collection('vendorCompanyName')
        .doc(companyName)
        .collection('vendorName')
        .doc(vendorName)
        .collection('problemsType')
        .get();

    if (requestTypeQuery.docs.isNotEmpty) {
      for (int i = 0; i < requestTypeQuery.docs.length; i++) {
        allRequestType.add(requestTypeQuery.docs[i].id);
      }
      allRequest = allRequestType;
    }
    // print('${allRequest}');
  }
}
