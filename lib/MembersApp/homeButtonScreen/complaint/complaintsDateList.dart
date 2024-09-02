import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/complaint/complaintsResponse.dart';
import 'package:societyuser_app/MembersApp/provider/AllComplaintProvider.dart';

// ignore: camel_case_types, must_be_immutable
class ComplaintDateList extends StatefulWidget {
  ComplaintDateList(
      {super.key,
      this.flatno,
      this.societyName,
      this.username,
      required this.complaintsType});
  String? flatno;
  String? societyName;
  String? username;
  String complaintsType;

  @override
  State<ComplaintDateList> createState() => _ComplaintDateListState();
}

// ignore: camel_case_types
class _ComplaintDateListState extends State<ComplaintDateList> {
  @override
  void initState() {
    fetchData(widget.complaintsType).whenComplete(() => setState(() {
          isLoading = false;
        }));
    super.initState();
  }

  List<dynamic> ComplaintDateList = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Text(
          'Date Of Complaints ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      // drawer: const MyDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                                  ' Society Manager',
                                  style: TextStyle(
                                      fontSize: 14,
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  // padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildInfoRow(context, Icons.person,
                                          "Member Name", widget.username!),
                                      buildInfoRow(context, Icons.home,
                                          "Flat No.", widget.flatno!),
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
                    ComplaintDateList.isEmpty
                        ? const Text('No Complaints')
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.69,
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: ComplaintDateList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(
                                          ComplaintDateList[index].toString(),
                                        ),
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ViewComplaints(
                                              complaintsType:
                                                  widget.complaintsType,
                                              society: widget.societyName,
                                              date: ComplaintDateList[index]
                                                  .toString(),
                                              flatNo: widget.flatno,
                                            );
                                          }));
                                        },
                                      ),
                                    );
                                  }),
                            ))
                  ],
                ),
              ),
            ),

      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 5),
      //   child: FloatingActionButton(
      //     backgroundColor: buttonColor,
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (context) {
      //         return ApplyComplaints(
      //           flatno: widget.flatno,
      //           societyName: widget.societyName,
      //         );
      //       }));
      //     },
      //     child: Icon(
      //       Icons.add,
      //       size: 30,
      //       color: buttonTextColor,
      //     ),
      //   ),
      // ),
    );
  }


  Future<void> fetchData(String complaintsType) async {
    final provider = Provider.of<AllComplaintProvider>(context, listen: false);
    provider.setBuilderList([]);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofcomplaints')
          .doc(complaintsType)
          .collection('dateOfComplaint')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> tempData = querySnapshot.docs.map((e) => e.id).toList();
        ComplaintDateList = tempData;
        provider.setBuilderList(tempData);
      }
    } catch (e) {
      // ignore: avoid_print
      // print('Error fetching data: $e');
    }
  }
}
