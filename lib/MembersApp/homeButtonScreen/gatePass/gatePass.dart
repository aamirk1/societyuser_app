// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/gatePass/applyGatePass.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/gatePass/viewGatePassResponse.dart';
import 'package:societyuser_app/MembersApp/provider/AllGatePassProvider.dart';

// ignore: camel_case_types, must_be_immutable
class GatePass extends StatefulWidget {
  GatePass({super.key, this.flatno, this.societyName, this.username});
  String? flatno;
  String? societyName;
  String? username;

  @override
  State<GatePass> createState() => _GatePassState();
}

// ignore: camel_case_types
class _GatePassState extends State<GatePass> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  List<String> nocData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Gate Pass',
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
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                Icons.person, "Member Name", widget.username!),
                            _buildInfoRow(
                                Icons.house, "Flat No.", widget.flatno!),
                            _buildInfoRow(Icons.home, "Society Name",
                                widget.societyName!),
                            // Text("Memeber Name: ${widget.username}"),
                            // Text("Flat No.: ${widget.flatno}"),
                            // Text("Society Name: ${widget.societyName}"),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      Consumer<AllGatePassProvider>(
                          builder: (context, value, child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.69,
                          child: ListView.builder(
                            itemCount: value.gatePassList.length,
                            itemBuilder: (BuildContext context, int index) {
                              // print(value.gatePassList);
                              return Column(
                                children: [
                                  ListTile(
                                    title: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ViewGatePass(
                                                gatePassType:
                                                    value.gatePassList[index]
                                                        ['gatePassType'],
                                                societyName:
                                                    widget.societyName!,
                                                flatNo: widget.flatno!,
                                                text: value.gatePassList[index]
                                                    ['text'],
                                              );
                                            },
                                          ),
                                        ).whenComplete(() => fetchData());
                                      },
                                      child: Text(
                                        value.gatePassList[index]
                                            ['gatePassType'],
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  ),
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
        padding: const EdgeInsets.only(bottom: 5.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ApplyGatePass(
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 30),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14.0),
            )
          ],
        )
      ],
    );
  }

  Future<void> fetchData() async {
    final provider = Provider.of<AllGatePassProvider>(context, listen: false);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('gatePassApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('gatePassType')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> tempData =
            querySnapshot.docs.map((e) => e.data()).toList();
        provider.setBuilderList(tempData);
      }
      // print(provider.gatePassList);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }
}
