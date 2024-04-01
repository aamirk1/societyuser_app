import 'package:flutter/material.dart';

var appBarBgColor = const Color.fromARGB(255, 3, 38, 240);
var textColor = const Color.fromARGB(255, 0, 0, 0);
var buttonColor = const Color.fromARGB(255, 3, 38, 240);
var buttonTextColor = const Color.fromARGB(255, 255, 255, 255);

Widget buildInfoRow(
    BuildContext context, IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 25),
      const SizedBox(width: 10.0),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 5.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
