import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/homeButtonScreen/gatePass/applyGatePass.dart';
import 'package:societyuser_app/homeButtonScreen/gatePass/viewGatePassResponse.dart';
import 'package:societyuser_app/provider/AllGatePassProvider.dart';

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
                      Consumer<AllGatePassProvider>(
                          builder: (context, value, child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.69,
                          child: ListView.builder(
                            itemCount: value.gatePassList.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(value.gatePassList);
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
                                                title: value.gatePassList[index]
                                                    ['gatePassType'],
                                                text: value.gatePassList[index]
                                                    ['text'],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        value.gatePassList[index]
                                            ['gatePassType'],
                                        style: const TextStyle(
                                            color: Colors.black),
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
      print(provider.gatePassList);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
    }
  }
}
