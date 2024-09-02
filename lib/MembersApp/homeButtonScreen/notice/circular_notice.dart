// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/notice/noticePdf.dart';
import 'package:societyuser_app/MembersApp/homeButtonScreen/notice/viewNotice.dart';
import 'package:societyuser_app/MembersApp/provider/AllNoticeProvider.dart';

// ignore: camel_case_types
class circular_notice extends StatefulWidget {
  circular_notice({super.key, this.flatno, this.societyName, this.username});

  String? flatno;
  String? societyName;
  String? username;

  @override
  State<circular_notice> createState() => _circular_noticeState();
}

// ignore: camel_case_types
class _circular_noticeState extends State<circular_notice> {
  List<dynamic> Allnotice = [];
  List<String> fileList = [];
  List<dynamic> urlList = [];
  String url = '';
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        setState(() {
          _isLoading = false;
        });
      },
    );
    super.initState();
    getNotice(widget.societyName);
    getNoticePdf(widget.societyName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: Text(
          'Circular Notice',
          style: TextStyle(color: buttonTextColor),
        ),
      ),
      // drawer: const MyDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0), // down 2 lines
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInfoRow(context, Icons.person, "Member Name",
                                  widget.username!),
                              buildInfoRow(context, Icons.home, "Flat No.",
                                  widget.flatno!),
                              buildInfoRow(context, Icons.location_city,
                                  "Society Name", widget.societyName!),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        Material(
                          child: SingleChildScrollView(
                            child: Consumer<AllNoticeProvider>(
                              builder: (context, value, child) => Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: value.noticeList.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ListTile(
                                              minVerticalPadding: 0.3,
                                              title: Text(
                                                value.noticeList[index]
                                                    ['title'],
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              trailing: Icon(
                                                Icons.message_rounded,
                                                color: textColor,
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return ViewNotice(
                                                        society:
                                                            widget.societyName,
                                                        title: value.noticeList[
                                                            index]['title'],
                                                        notice: value
                                                                .noticeList[
                                                            index]['notice'],
                                                        date: value.noticeList[
                                                            index]['date']);
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                  ListView.builder(
                                      // itemCount: value.noticePdfList.length,
                                      itemCount: fileList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: ListTile(
                                              minVerticalPadding: 0.3,
                                              title: Text(
                                                fileList[index].toString(),
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              trailing: const Icon(
                                                Icons.picture_as_pdf_rounded,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return MyPdfViewer(
                                                    downloadUrl: urlList[index],
                                                    pdfPath: urlList[index],
                                                  );
                                                }));
                                              },
                                            ),
                                          ),
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
    );
  }


  Future<void> getNotice(String? SelectedSociety) async {
    final provider = Provider.of<AllNoticeProvider>(context, listen: false);

    QuerySnapshot getAllNotice = await FirebaseFirestore.instance
        .collection('notice')
        .doc(SelectedSociety)
        .collection('notices')
        .get();
    List<dynamic> allTypeOfNotice =
        getAllNotice.docs.map((e) => e.data()).toList();
    // print('aaaa - $allTypeOfNotice');
    Allnotice = allTypeOfNotice;
    provider.setBuilderNoticeList(allTypeOfNotice);
  }

  Future<List<String>> getNoticePdf(String? selectedSociety) async {
    // final provider = Provider.of<AllNoticeProvider>(context, listen: false);

    // List<String> fileList = [];

    ListResult listResult = await FirebaseStorage.instance
        .ref('Notices')
        .child(selectedSociety!)
        .listAll();

    for (Reference ref in listResult.items) {
      urlList.add(await ref.getDownloadURL());
      String filename = ref.name;
      fileList.add(filename);
    }
    setState(() {
      fileList = fileList;
    });
    return fileList;
  }

  openPdf(String title) async {
    final storage = FirebaseStorage.instance;
    final Reference ref =
        storage.ref('Notices').child(widget.societyName!).child(title);
    String url = await ref.getDownloadURL();

    return url;
  }
}
