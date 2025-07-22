import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SupplierInfo extends ChangeNotifier {
  String _cif = "";
  String get cif => _cif;

  set cif(String value) {
    _cif = value;
    notifyListeners();
  }

  String _token = '';
  String get token => _token;

  set token(String value) {
    _token = value;
    notifyListeners();
  }

String _countryCode = '';
  String get countryCode => _countryCode;

  set countryCode(String value) {
    _countryCode = value;
    notifyListeners();
  }

  String _mail = '';
  String get mail => _mail;

  set mail(String value) {
    _mail = value;
    notifyListeners();
  }

  String _phone = '';
  String get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }
}
