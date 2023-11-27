import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:societyuser_app/common_widget/colors.dart';

class apply_noc extends StatefulWidget {
  apply_noc({super.key});
  @override
  State<apply_noc> createState() => _apply_nocState();

  List<String> items = [
    'SALE NOC',
    'GAS NOC',
    'ELECTRIC METER NOC',
    'PASSPORT NOC',
    'RENOVATION NOC',
    'NOC FOR GIFT DEED',
    'BANK',
  ];
}

class _apply_nocState extends State<apply_noc> {
  // final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController noctypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        title: const Text(
          'Apply NOC',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: noctypeController,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 10),
                      decoration: const InputDecoration(
                          labelText: 'select NOC',
                          border: OutlineInputBorder())),
                  suggestionsCallback: (pattern) async {
                    // return await getSocietyList();
                    return widget.items;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(
                        suggestion.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    noctypeController.text = suggestion.toString();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => societyDetails(
                    //         societyNames: suggestion.toString()),
                    //   ),
                    // );
                  },
                ),
              ),
            const  SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
