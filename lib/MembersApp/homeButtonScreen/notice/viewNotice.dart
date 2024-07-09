// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class ViewNotice extends StatefulWidget {
  ViewNotice(
      {super.key, this.society, required this.title, this.notice, this.date});
  String? notice;
  String? date;
  String? society;
  String? title;
  @override
  State<ViewNotice> createState() => _ViewNoticeState();
}

class _ViewNoticeState extends State<ViewNotice> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // getTypeOfNoc(widget.society, widget.flatNo, widget.nocType,widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'View Notice',
          style: TextStyle(color: buttonTextColor),
        ),
        backgroundColor: appBarBgColor,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Date: ${widget.date!}',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                widget.title!,
                style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ]),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: Text(
                        widget.notice!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: textColor),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
