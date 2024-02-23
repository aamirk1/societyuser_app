// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AllNoticeProvider extends ChangeNotifier {
  List<dynamic> _noticeList = [];
  List<dynamic> get noticeList => _noticeList;

  List<dynamic> _noticePdfList = [];
  List<dynamic> get noticePdfList => _noticePdfList;

  void setBuilderNoticeList(List<dynamic> value) {
    _noticeList = value;
    notifyListeners();
  }

  void setBuilderNoticePdfList(List<dynamic> value) {
    _noticePdfList = value;
    notifyListeners();
  }
}
