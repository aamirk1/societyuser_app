// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class DateOfGatePass extends ChangeNotifier {
  List<dynamic> _dateGatePassList = [];
  List<dynamic> get dateGatePassList => _dateGatePassList;

  void addList(List<dynamic> list) {
    _dateGatePassList = dateGatePassList;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _dateGatePassList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _dateGatePassList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _dateGatePassList.removeAt(value);
    notifyListeners();
  }
}
