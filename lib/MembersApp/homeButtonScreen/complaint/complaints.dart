import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/complaint/applyComplaint.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/complaint/complaintsResponse.dart';
import 'package:societyuser_app/MembersApp/provider/AllComplaintProvider.dart';

// ignore: camel_case_types, must_be_immutable
class Complaints extends StatefulWidget {
  Complaints({super.key, this.flatno, this.societyName, this.username});
  String? flatno;
  String? societyName;
  String? username;

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
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shadowColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dev Accounts -',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Text(
                            ' Society Manager App',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            // padding: const EdgeInsets.all(2.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildInfoRow(context, Icons.person,
                                    "Member Name", widget.username!),
                                buildInfoRow(context, Icons.home, "Flat No.",
                                    widget.flatno!),
                                buildInfoRow(context, Icons.home,
                                    "Society Name", widget.societyName!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<AllComplaintProvider>(builder: (context, value, child) {
                return value.complaintList.isEmpty
                    ? Center(
                        child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        alignment: Alignment.center,
                        child: const Text(
                          'No Complaints Available.',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ))
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.69,
                        child: GridView.builder(
                            itemCount: value.complaintList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1.2,
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: textColor)),
                                child: Column(children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ViewComplaints(
                                                complaintsType:
                                                    value.complaintList[index]
                                                        ['complaintsType'],
                                                text: value.complaintList[index]
                                                    ['text'],
                                              );
                                            },
                                          ),
                                        ).whenComplete(() => fetchData());
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          getIcon(value.complaintList[index]
                                              ['complaintsType']),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            value.complaintList[index]
                                                ['complaintsType'],
                                            style: TextStyle(
                                                color: textColor, fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )),
                                ]),
                              );
                            }),
                      );
              })
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ApplyComplaints(
                flatno: widget.flatno,
                societyName: widget.societyName,
              );
            }));
          },
          child: Icon(
            Icons.add,
            size: 30,
            color: buttonTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> fetchData() async {
    final provider = Provider.of<AllComplaintProvider>(context, listen: false);
    provider.setBuilderList([]);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofcomplaints')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> tempData =
            querySnapshot.docs.map((e) => e.data()).toList();
        provider.setBuilderList(tempData);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }

  Widget getIcon(String iconName) {
    switch (iconName) {
      case "House Keeping Complaint":
        return const Icon(
          Icons.home_max_rounded,
          size: 30,
        );
      case "Security Issues":
        return const Icon(
          Icons.security_rounded,
          size: 30,
        );
      case "Parking Issue":
        return const Icon(
          Icons.car_repair_rounded,
          size: 30,
        );
      case "Admin Issue":
        return const Icon(
          Icons.person_2_sharp,
          size: 30,
        );
      case "Accounts Issue":
        return const Icon(
          Icons.account_balance_rounded,
          size: 30,
        );
      case "Vendor Complaints":
        return const Icon(
          Icons.person_3_rounded,
          size: 30,
        );
      case "Water Related":
        return const Icon(
          Icons.water_rounded,
          size: 30,
        );
      case "Leackage Related":
        return const Icon(
          Icons.water_drop_rounded,
        );
      case "Pet Animals Related":
        return const Icon(
          Icons.gif_box_rounded,
        );
      case "Others":
        return const Icon(
          Icons.gif_box_rounded,
        );
      default:
        return const Icon(
          Icons.construction_rounded,
          size: 30,
        );
    }
  }
}
