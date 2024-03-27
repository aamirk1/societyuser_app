import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/noc/applyNoc.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/noc/nocResponse.dart';
import 'package:societyuser_app/MembersApp/provider/AllNocProvider.dart';

// ignore: camel_case_types, must_be_immutable
class nocPage extends StatefulWidget {
  nocPage({super.key, this.flatno, this.societyName, this.username});
  String? flatno;
  String? societyName;
  String? username;

  @override
  State<nocPage> createState() => _nocPageState();
}

// ignore: camel_case_types
class _nocPageState extends State<nocPage> {
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
          'NOC ',
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                      Text(
                        ' Society Manager App',
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
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        width: MediaQuery.of(context).size.width, //up 2lines
                        height: MediaQuery.of(context).size.height * 0.2,
                        // padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                Icons.person, "Member Name", widget.username!),
                            _buildInfoRow(
                                Icons.home, "Flat No.", widget.flatno!),
                            _buildInfoRow(Icons.location_city, "Society Name",
                                widget.societyName!),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Consumer<AllNocProvider>(
                          builder: (context, value, child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.69,
                          child: GridView.builder(
                              itemCount: value.nocList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 1.1,
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
                                                return ViewNoc(
                                                  nocType: value.nocList[index]
                                                      ['nocType'],
                                                  societyName:
                                                      widget.societyName!,
                                                  flatNo: widget.flatno!,
                                                  text: value.nocList[index]
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
                                            getIcon(value.nocList[index]
                                                ['nocType']),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              value.nocList[index]['nocType'],
                                              style:
                                                  TextStyle(color: textColor),
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom: 5.0),
        child: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return apply_noc(
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
    final provider = Provider.of<AllNocProvider>(context, listen: false);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('nocApplications')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofNoc')
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
      case "SALE NOC":
        return const Icon(
          Icons.sell_rounded,
          size: 30,
        );
      case "GAS NOC":
        return const Icon(
          Icons.gas_meter_rounded,
          size: 30,
        );
      case "RENOVATION NOC":
        return const Icon(
          Icons.construction_rounded,
          size: 30,
        );
      case "ELECTRIC METER NOC":
        return const Icon(
          Icons.electric_bolt_rounded,
          size: 30,
        );
      case "PASSPORT NOC":
        return const Icon(
          Icons.book_rounded,
          size: 30,
        );
      case "NOC FOR GIFT DEED":
        return const Icon(
          Icons.gif_box_rounded,
          size: 30,
        );
      case "BANK":
        return const Icon(
          Icons.business_outlined,
          size: 30,
        );
      default:
        return const Icon(
          Icons.construction_rounded,
          size: 30,
        );
    }
  }

  // List<dynamic> nocIcons = [
  //   const Icon(Icons.balance_rounded, size: 30).toString(),
  //   const Icon(Icons.gas_meter_rounded, size: 30).toString(),
  //   const Icon(Icons.electric_bike_rounded, size: 30).toString(),
  //   const .toString(),
  // ];
}
