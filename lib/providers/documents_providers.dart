import 'package:flutter/foundation.dart';
import 'package:proyecto_fct_facturas/models/UploadedFile.dart';
import 'package:proyecto_fct_facturas/models/getUploadedFiles.dart';

class DocumentsProvider extends ChangeNotifier {
  bool _loading = false;

  List<UploadedFile> _pedidos = [];
  List<getDoc> _orders = [];


  String _error = '';

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  List<UploadedFile> get pedidos => _pedidos;

  set pedidos(List<UploadedFile> value) {
    _pedidos = value;
    notifyListeners();
  }

  addDocument(UploadedFile value){
    _pedidos.insert(0, value);
    notifyListeners();
  }

  List<getDoc> get orders => _orders;

  set orders(List<getDoc> value) {
    _orders = value;
    notifyListeners();
  }

  addDocumentOrders(getDoc value){
    _orders.insert(0, value);
    notifyListeners();
  }


  Uint8List? _bytes;

  Uint8List? get bytes =>  _bytes;

  set bytes (Uint8List? value){
    _bytes = value;
    notifyListeners();
  }

  String _name = '';

  String get name => _name;

  set name (String value) {
    _name = value;
    notifyListeners();
  }

    String _hash = '';

  String get hash => _hash;

  set hash (String value) {
    _hash = value;
    notifyListeners();
  }
int _size = 0;

  int get size => _size;

  set size (int value) {
    _size = value;
    notifyListeners();
  }

bool _uploadError = false;

bool get uploadError => _uploadError;

set uploadError (bool value){
  _uploadError = value;
  notifyListeners();
}

String _url ='';

  String get url => _url;

  set url (String value){
    _url = value;
    notifyListeners();
  }

bool _fileUploaded = false;

bool get fileUploaded => _fileUploaded;
set fileUploaded (bool value){
  _fileUploaded = value;
  notifyListeners();
}
String _mime = '';

  String get mime => _mime;

set mime (String value){
    _mime = value;
    notifyListeners();
  }

String _fichero = '';

  String get fichero => _fichero;

  set fichero (String value){
    _fichero = value;
    notifyListeners();
  } 
String _nombreFichero = '';

  String get nombreFichero => _nombreFichero;

  set nombreFichero (String value){
    _nombreFichero = value;
    notifyListeners();
  } 

}
