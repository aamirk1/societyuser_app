// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/list_builder_provider.dart';
import 'package:societyuser_app/VendorsApp/VendorHomeButtonScreen/serviceRequest/ListOfServiceRequestType.dart';

// ignore: must_be_immutable
class ServiceRequestFlatNo extends StatefulWidget {
  ServiceRequestFlatNo({super.key, required this.email});
  String email;

  @override
  State<ServiceRequestFlatNo> createState() => _ServiceRequestFlatNoState();
}

class _ServiceRequestFlatNoState extends State<ServiceRequestFlatNo> {
  TextEditingController societyNameController = TextEditingController();

  Map<String, dynamic> vendorDetails = {};
  String companyName = '';
  List<String> allSociety = [];
  bool isLoading = true;
  String? selectedSocietyName;
  List<dynamic> allFlatNo = [];
  @override
  void initState() {
    getSocietyName().whenComplete(() async {
      await fetchVendorDetails(widget.email);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    // getCompany(widget.societyName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Service Provider'),
        backgroundColor: appBarBgColor,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 12,
          //     height: MediaQuery.of(context).size.height * 0.09,
          //     padding: const EdgeInsets.all(8),
          //     child: TypeAheadField(
          //       textFieldConfiguration: TextFieldConfiguration(
          //           controller: societyNameController,
          //           style: DefaultTextStyle.of(context).style.copyWith(
          //               fontSize: 14, color: Color.fromARGB(255, 3, 3, 3)),
          //           decoration: const InputDecoration(
          //               labelText: 'Select Society',
          //               labelStyle: TextStyle(
          //                 color: Color.fromARGB(255, 0, 0, 0),
          //               ),
          //               border: OutlineInputBorder())),
          //       suggestionsCallback: (pattern) async {
          //         return await getSocietyName();
          //       },
          //       itemBuilder: (context, suggestion) {
          //         return ListTile(
          //           title: Text(suggestion.toString()),
          //         );
          //       },
          //       onSuggestionSelected: (suggestion) {
          //         societyNameController.text = suggestion.toString();
          //         fetchFlatNoList(societyNameController.text);
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          Container(
            color: Colors.white,
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Text(
                  'Select society name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                items: allSociety
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        ))
                    .toList(),
                value: selectedSocietyName,
                onChanged: (value) {
                  fetchFlatNoList(value!).whenComplete(() {
                    setState(() {
                      selectedSocietyName = value;
                    });
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  width: 200,
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: societyNameController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: societyNameController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search society name...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    societyNameController.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 12,
              height: MediaQuery.of(context).size.height * 0.09,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allFlatNo.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                        title: Text(
                          allFlatNo[index],
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ListOfServiceRequestType(
                                  email: widget.email,
                                  flatNo: allFlatNo[index],
                                  societyName: selectedSocietyName!,
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

  Future<void> fetchVendorDetails(String currentEmail) async {
    DocumentSnapshot flatNoQuery = await FirebaseFirestore.instance
        .collection('vendorsLoginDetails')
        .doc(currentEmail)
        .get();
    vendorDetails = flatNoQuery.data() as Map<String, dynamic>;
    companyName = vendorDetails['companyName'];
  }

  Future<List<String>> getSocietyName() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();

    allSociety = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    return allSociety;
  }

  Future<List<dynamic>> fetchFlatNoList(String selectedSociety) async {
    QuerySnapshot flatNoList = await FirebaseFirestore.instance
        .collection('sendComplaintsForVendors')
        .doc(selectedSociety)
        .collection('flatno')
        .get();
    allFlatNo = flatNoList.docs.map((e) => e.id).toList();
    print(allFlatNo);

    return allFlatNo;
  }

  Future<void> deleteEmp(
      String selectedSociety, String company, int index) async {
    final provider = Provider.of<ListBuilderProvider>(context, listen: false);
    DocumentReference deleteEmployee = FirebaseFirestore.instance
        .collection('vendorList')
        .doc(selectedSociety)
        .collection('companyList')
        .doc(company);

    await deleteEmployee.delete();

    provider.removeData(index);
  }

  alertbox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: TextStyle(color: textColor),
                    )),
              ],
              title: const Text(
                'Please select a file first!',
                style: TextStyle(color: Colors.red),
              ));
        });
  }
}
