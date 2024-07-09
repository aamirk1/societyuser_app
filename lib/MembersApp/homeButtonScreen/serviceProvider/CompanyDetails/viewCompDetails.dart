// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

class ViewCompanyData extends StatefulWidget {
  const ViewCompanyData({
    super.key,
    required this.companyName,
    required this.comEmail,
    required this.comPhone,
    required this.comAddress,
  });
  final String companyName;
  final String comEmail;
  final String comPhone;
  final String comAddress;

  @override
  State<ViewCompanyData> createState() => _ViewCompanyDataState();
}

class _ViewCompanyDataState extends State<ViewCompanyData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'View Full Detais of ${widget.companyName}',
          style: TextStyle(color: buttonTextColor),
        ),
        backgroundColor: appBarBgColor,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          height: MediaQuery.of(context).size.height * 0.40,
          child: Card(
            elevation: 15,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Company Name: ${widget.companyName}',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              const SizedBox(
                height: 7,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${widget.comEmail}',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Mobile: ${widget.comPhone}',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Address: ${widget.comAddress}',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 15),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back',
                        style: TextStyle(color: textColor, fontSize: 18),
                      )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
