// ignore_for_file: file_names

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: must_be_immutable
class ViewNoc extends StatefulWidget {
  ViewNoc({
    super.key,
    required this.nocType,
    required this.societyName,
    required this.flatNo,
    required this.text,
  });
  String nocType;
  String societyName;
  String flatNo;
  String text;
  @override
  State<ViewNoc> createState() => _ViewNocState();
}

class _ViewNocState extends State<ViewNoc> {
  bool isDownloading = false;
  List<dynamic> dataList = [];
  String url = '';
  String filename = '';
  List<String> fileList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getNocPdf(widget.societyName, widget.flatNo, widget.nocType)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    // getTypeOfNoc(widget.society, widget.flatNo, widget.nocType,widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.98,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.nocType,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    widget.text,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            url != '' && fileList.isNotEmpty
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                      Colors.green,
                                    )),
                                    onPressed: () {},
                                    child: const Text('Download'),
                                  )
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                      Colors.amber,
                                    )),
                                    onPressed: () {
                                      alertbox();
                                    },
                                    child: const Text('Pending'),
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<List<String>> getNocPdf(
      // ignore: non_constant_identifier_names
      String? SelectedSociety,
      String flatNo,
      String nocType) async {
    ListResult listResult = await FirebaseStorage.instance
        .ref('NocPdfs')
        .child(SelectedSociety!)
        .child(flatNo)
        .child(nocType)
        .list();

    filename = listResult.items.first.name;
    url = await listResult.items.first.getDownloadURL();
    fileList.add(filename);
    return fileList;
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
              'Application in progress',
              style: TextStyle(color: Colors.red),
            ),
          );
        });
  }
}
