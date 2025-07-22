import 'package:flutter/material.dart';

class FileDropped extends ChangeNotifier {
  String _url = '';

  String get url => _url;

  set url(String value) {
    _url = value;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String _mime = '';
  String get mime => _mime;

  set mime(String value) {
    _mime = value;
    notifyListeners();
  }

  int _bytes = 0;
  int get bytes => _bytes;

  set bytes(int value) {
    _bytes = value;
    notifyListeners();
  }

  int _hash = 0;
  int get hash => _hash;

  set hash(int value) {
    _hash = value;
    notifyListeners();
  }
}
