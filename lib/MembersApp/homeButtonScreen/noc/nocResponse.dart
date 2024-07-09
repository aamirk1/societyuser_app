// ignore_for_file: file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/AllNocProvider.dart';

// ignore: must_be_immutable
class ViewNoc extends StatefulWidget {
  ViewNoc(
      {super.key,
      required this.nocType,
      required this.societyName,
      required this.flatNo,
      // required this.text,
      required this.date});
  String nocType;
  String societyName;
  String flatNo;
  // String text;
  String date;
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
  Map<String, dynamic> nocData = {};
  String? SelectedSociety;
  String? flatNo;
  String? nocType;
  @override
  void initState() {
    super.initState();
    fetchData(widget.societyName, widget.flatNo, widget.nocType, widget.date)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    getNocPdf(widget.societyName, widget.flatNo, widget.nocType, widget.date)
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
                            height: MediaQuery.of(context).size.height * 0.80,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.nocType,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: textColor),
                                  ),
                                  Text(
                                    nocData['text'] ?? 'No Text Given',
                                    style: TextStyle(
                                        fontSize: 12, color: textColor),
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
                                    onPressed: () {
                                      downloadPdf();
                                    },
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
      selectedSociety, flatNo, nocType, dateOfNoc) async {
    ListResult listResult = await FirebaseStorage.instance
        .ref('NocPdfs')
        .child(selectedSociety!)
        .child(flatNo)
        .child(nocType)
        .child(dateOfNoc)
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

  Future<void> fetchData(
      String societyName, String flatNo, String nocType, String date) async {
    final provider = Provider.of<AllNocProvider>(context, listen: false);
    provider.setBuilderList([]);
    try {
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('nocApplications')
          .doc(societyName)
          .collection('flatno')
          .doc(flatNo)
          .collection('typeofNoc')
          .doc(nocType)
          .collection('dateOfNoc')
          .doc(date)
          .get();
      if (querySnapshot.data() != null) {
        Map<String, dynamic> tempData =
            querySnapshot.data() as Map<String, dynamic>;
        nocData = tempData;
      }
    } catch (e) {
      // ignore: avoid_print
      // print('Error fetching data: $e');
    }
  }

  Future<void> downloadPdf() async {
    final storage = FirebaseStorage.instance
        .ref('NocPdfs')
        .child(widget.societyName)
        .child(widget.flatNo)
        .child(widget.nocType);

    ListResult result = await storage.list();

    Uint8List? pdfData = await result.items.first.getData();
    String fileName = result.items.first.name;
    await savePDFToFile(pdfData!, fileName);
  }

  Future<File> savePDFToFile(Uint8List pdfData, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      final documentDirectory =
          (await DownloadsPath.downloadsDirectory())?.path;
      final file = File('$documentDirectory/$fileName');

      int counter = 1;
      String newFilePath = file.path;
      if (await File(newFilePath).exists()) {
        final baseName = fileName.split('.').first;
        final extension = fileName.split('.').last;
        newFilePath =
            '$documentDirectory/$baseName-${counter.toString()}.$extension';
        counter++;
        await file.copy(newFilePath);
        counter++;
      } else {
        await file.writeAsBytes(pdfData);
        return file;
      }
      // print('PDF downloaded Successfully');
    }
    return File('');
  }
}
