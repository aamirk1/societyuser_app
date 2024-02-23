import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/applyComplaint.dart';
import 'package:societyuser_app/homeButtonScreen/complaint/complaintsResponse.dart';
import 'package:societyuser_app/provider/AllComplaintProvider.dart';

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
          child: Card(
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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.10,
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Memeber Name: ${widget.username}"),
                            Text("Flat No.: ${widget.flatno}"),
                            Text("Society Name: ${widget.societyName}"),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      Consumer<AllComplaintProvider>(
                          builder: (context, value, child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.69,
                          child: ListView.builder(
                            itemCount: value.complaintList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  ListTile(
                                      title: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ViewComplaints(
                                                    complaintsType:
                                                        value.complaintList[
                                                                index]
                                                            ['complaintsType'],
                                                    text: value.complaintList[
                                                        index]['text'],
                                                  );
                                                },
                                              ),
                                            ).whenComplete(() => fetchData());
                                          },
                                          child: Text(
                                            value.complaintList[index]
                                                ['complaintsType'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ))),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ApplyComplaints(
                flatno: widget.flatno,
                societyName: widget.societyName,
              );
            }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final provider = Provider.of<AllComplaintProvider>(context, listen: false);
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
}
