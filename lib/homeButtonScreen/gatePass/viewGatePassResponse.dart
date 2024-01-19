// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';

// ignore: must_be_immutable
class ViewGatePass extends StatefulWidget {
  ViewGatePass({super.key, required this.title, required this.text});
  String? title;
  String? text;
  @override
  State<ViewGatePass> createState() => _ViewGatePassState();
}

class _ViewGatePassState extends State<ViewGatePass> {
  List<dynamic> dataList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Gate Pass',
          style: TextStyle(color: buttonTextColor),
        ),
        backgroundColor: appBarBgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  widget.title ?? '',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ]),
              const SizedBox(
                height: 7,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.79,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        child: Text(
                          widget.text ?? '',
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: textColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     widget.title != '' && widget.text != ''
              //         ? ElevatedButton(
              //             style: ButtonStyle(
              //                 backgroundColor: MaterialStateProperty.all(
              //               Colors.green,
              //             )),
              //             onPressed: () {},
              //             child: const Text('Download'),
              //           )
              //         : ElevatedButton(
              //             style: ButtonStyle(
              //                 backgroundColor: MaterialStateProperty.all(
              //               Colors.amber,
              //             )),
              //             onPressed: () {
              //               alertbox();
              //             },
              //             child: const Text('Pending'),
              //           )
              //   ],
              // ),
            ]),
          ),
        ),
      ),
    );
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
      },
    );
  }
}
