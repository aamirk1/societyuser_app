import 'package:flutter/material.dart';
import 'package:societyuser_app/membersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class ViewComplaintApplication extends StatefulWidget {
  ViewComplaintApplication(
      {super.key, required this.text, required this.requestType});

  String text;
  dynamic requestType;

  @override
  State<ViewComplaintApplication> createState() =>
      _ViewComplaintApplicationState();
}

class _ViewComplaintApplicationState extends State<ViewComplaintApplication> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            height: MediaQuery.of(context).size.height * 0.98,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.78,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.requestType,
                            style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: textColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.text,
                            style:  TextStyle(
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
