import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_fct_facturas/global/enviroment.dart';
import 'package:proyecto_fct_facturas/models/login.dart';

class AuthService with ChangeNotifier {
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

// Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
 
  // login _------------------------------------------------------------------------

  Future<bool> login(String mail, String phone) async {
    this.autenticando = true;

    final data = {
      'mail': mail,
      'phone': phone,
    };

    final Uri uri = Uri.parse('${Enviroment.apiUrl}/supplier_login/'); 
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;
    try {
      
    if (resp.statusCode.toString() == '200' && resp.body.toString() != 'null') {
      final loginResponse = loginFromJson(resp.body);
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
    } catch (e) {
     print(e); 
    }
    return false;
  }
  //esta logeado?
  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${Enviroment.apiUrl}/login/renew');
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final loginResponse = loginFromJson(resp.body);
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
