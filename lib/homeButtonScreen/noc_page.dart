import 'package:flutter/material.dart';
import 'package:societyuser_app/common_widget/colors.dart';
import 'package:societyuser_app/common_widget/drawer.dart';

class nocPage extends StatelessWidget {
  const nocPage({super.key});

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
      drawer: const MyDrawer(),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Passport'),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Name Change for Electric Meter'),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('No Objection Certificate for Sale'),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                            'No Objection Certificate for Sub-letting'),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                            'No Objection Certificate for Bank Loan'),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Nomination Form'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ])),
    );
  }
}
