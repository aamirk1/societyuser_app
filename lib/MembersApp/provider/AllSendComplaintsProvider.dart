// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllSendComplaintsProvider extends ChangeNotifier {
  List<dynamic> _sendComplaints = [];
  List<dynamic> get sendComplaints => _sendComplaints;

  void addList(List<dynamic> list) {
    _sendComplaints = sendComplaints;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _sendComplaints = value;
    notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _sendComplaints.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _sendComplaints.removeAt(value);
    notifyListeners();
  }
}
