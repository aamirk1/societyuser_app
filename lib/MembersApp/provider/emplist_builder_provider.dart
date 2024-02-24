import 'package:flutter/foundation.dart';

class EmpListBuilderProvider extends ChangeNotifier {
  List<dynamic> _empList = [];
  List<dynamic> get empList => _empList;

  final bool _load = false;
  bool get load => _load;

  void addList(List<dynamic> list) {
    _empList = empList;
    notifyListeners();
  }

  void addSingleList(Map<String, dynamic> value) {
    _empList.add(value);
    notifyListeners();
  }

  void setBuilderEmpList(List<dynamic> value) {
    
    _empList = value;
    notifyListeners();
  }

  void removeData(int value) {
    _empList.removeAt(value);
    notifyListeners();
  }
}
