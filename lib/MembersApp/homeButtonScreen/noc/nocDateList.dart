import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/noc/nocResponse.dart';
import 'package:societyuser_app/MembersApp/provider/AllComplaintProvider.dart';

// ignore: camel_case_types, must_be_immutable
class NocDateList extends StatefulWidget {
  NocDateList(
      {super.key,
      this.flatno,
      this.societyName,
      this.username,
      required this.nocType});
  String? flatno;
  String? societyName;
  String? username;
  String nocType;

  @override
  State<NocDateList> createState() => _NocDateListState();
}

// ignore: camel_case_types
class _NocDateListState extends State<NocDateList> {
  @override
  void initState() {
    fetchData(widget.nocType).whenComplete(() => setState(() {
          isLoading = false;
        }));
    super.initState();
  }

  List<dynamic> NocDateList = [];
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Text(
          'Date Of NOC ',
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
                    NocDateList.isEmpty
                        ? Center(
                            child: const Text(
                            'No Noc Found',
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ))
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.69,
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: NocDateList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 5,
                                      child: ListTile(
                                        title: Text(
                                          NocDateList[index].toString(),
                                        ),
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ViewNoc(
                                              nocType: widget.nocType,
                                              societyName: widget.societyName!,
                                              // text:nocList[index]
                                              //     ['text'],
                                              date:
                                                  NocDateList[index].toString(),
                                              flatNo: widget.flatno!,
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


  Future<void> fetchData(String nocType) async {
    final provider = Provider.of<AllComplaintProvider>(context, listen: false);
    provider.setBuilderList([]);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('nocApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofNoc')
          .doc(nocType)
          .collection('dateOfNoc')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> tempData = querySnapshot.docs.map((e) => e.id).toList();
        NocDateList = tempData;
        // print('NocDateList: $NocDateList');
        provider.setBuilderList(tempData);
      }
    } catch (e) {
      // ignore: avoid_print
      // print('Error fetching data: $e');
    }
  }
}
