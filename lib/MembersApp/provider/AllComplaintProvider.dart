// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllComplaintProvider extends ChangeNotifier {
  List<dynamic> _complaintList = [];
  List<dynamic> get complaintList => _complaintList;

  void addList(List<dynamic> list) {
    _complaintList = complaintList;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _complaintList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _complaintList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _complaintList.removeAt(value);
    notifyListeners();
  }
}
