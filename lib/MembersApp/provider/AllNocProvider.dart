// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllNocProvider extends ChangeNotifier {
  List<dynamic> _nocList = [];
  List<dynamic> get nocList => _nocList;

  void addList(List<dynamic> list) {
    _nocList = nocList;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _nocList = value;
    // notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _nocList.add(value);
    notifyListeners();
  }

  void removeData(int value) {
    _nocList.removeAt(value);
    notifyListeners();
  }
}
