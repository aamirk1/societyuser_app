// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/gatePass/applyGatePass.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/gatePass/gatepassDateList.dart';
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
    fetchData().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  List<String> nocData = [];
  List<dynamic> checkResult = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Text(
          'Gate Pass',
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
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildInfoRow(context, Icons.person,
                                          "Member Name", widget.username!),
                                      buildInfoRow(context, Icons.house,
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
                      height: 10,
                    ),
                    Consumer<AllGatePassProvider>(
                        builder: (context, value, child) {
                      return value.gatePassList.isEmpty
                          ? Center(
                              child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2,
                              alignment: Alignment.center,
                              child: const Text(
                                'No Gate Pass Available.',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ))
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.69,
                              child: GridView.builder(
                                  itemCount: value.gatePassList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisSpacing: 10.0,
                                          crossAxisSpacing: 10.0,
                                          childAspectRatio: 3,
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return Column(children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: checkResult[index]
                                                    ['isApproved'] ==
                                                true
                                            ? const Color.fromARGB(
                                                255, 1, 150, 11)
                                            : checkResult[index]
                                                        ['isRejected'] ==
                                                    true
                                                ? Colors.red[800]
                                                : Colors.yellow[800],
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return GatePassDateList(
                                                    username: widget.username,
                                                    gatePassType: value
                                                            .gatePassList[index]
                                                        ['gatePassType'],
                                                    societyName:
                                                        widget.societyName!,
                                                    flatno: widget.flatno,
                                                    // text: value
                                                    //         .gatePassList[index]
                                                    //     ['text'],
                                                  );
                                                },
                                              ),
                                            ).whenComplete(() => fetchData());
                                          },
                                          child: Text(
                                            value.gatePassList[index]
                                                    ['gatePassType']
                                                .toString(),
                                            style: TextStyle(
                                                color: buttonTextColor,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }),
                            );
                    })
                  ],
                ),
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ApplyGatePass(
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

  Future<void> fetchData() async {
    final provider = Provider.of<AllGatePassProvider>(context, listen: false);
    provider.setBuilderList([]);
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

        checkResult = tempData;
        print('checkResult: $checkResult');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }

  customDialogBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'No Gate Pass Applications Found',
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: textColor),
                  )),
            ],
          );
        });
  }
}
