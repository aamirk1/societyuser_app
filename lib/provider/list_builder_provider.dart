import 'package:flutter/foundation.dart';

class ListBuilderProvider extends ChangeNotifier {
  List<dynamic> _list = [];
  List<dynamic> get list => _list;

  List<dynamic> _empList = [];
  List<dynamic> get empList => _empList;

  void addList(List<dynamic> list) {
    _list = list;
    notifyListeners();
  }

  void setBuilderList(List<dynamic> value) {
    _list = value;
    notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _list.add(value);
    notifyListeners();
  }

  void setBuilderEmpList(List<dynamic> value) {
    _empList = value;
    notifyListeners();
  }

  void removeData(int value) {
    _list.removeAt(value);
    notifyListeners();
  }
}
