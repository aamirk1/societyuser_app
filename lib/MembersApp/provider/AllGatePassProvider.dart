// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllGatePassProvider extends ChangeNotifier {
  List<dynamic> _gatePassList = [];
  List<dynamic> get gatePassList => _gatePassList;

  void addList(List<dynamic> list) {
    _gatePassList = gatePassList;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _gatePassList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _gatePassList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _gatePassList.removeAt(value);
    notifyListeners();
  }
}
