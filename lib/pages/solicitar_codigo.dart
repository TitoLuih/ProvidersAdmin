import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/global/enviroment.dart';

import 'package:proyecto_fct_facturas/helpers/mostrar_alerta.dart';
import 'package:proyecto_fct_facturas/pages/confirmacion_codigo.dart';
import 'package:proyecto_fct_facturas/providers/supplier_info.dart';
import 'package:proyecto_fct_facturas/services/auth_service.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:http/http.dart' as http;

class SolicitarCodigo extends StatefulWidget {
  SolicitarCodigo({super.key});

  @override
  State<SolicitarCodigo> createState() => _SolicitarCodigoState();
}

class _SolicitarCodigoState extends State<SolicitarCodigo> {
  //declaracion de variablesf
  final controladorEmail = TextEditingController();
  final controladorNumero = TextEditingController();

  String countryCode = '';
  final FocusNode _focusNode = FocusNode();
  FocusNode focusNode = FocusNode();

  bool cargando = false;
  bool emailVacio = false;
  bool emailMal = false;
  bool numVacio = false;
  bool numMal = false;

  int longNum = 0;

  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(_handleFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCountryCode().then((snapshot) {
        setState(() {
          countryCode = snapshot;
        });
      });
    });
    setState(() {
      countryCode = 'ES';
    });
  }

  @override
  void dispose() {
    // _focusNode.removeListener(_handleFocusChange);
    // _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleButtonPress() async {
    final supplierInfo = Provider.of<SupplierInfo>(context, listen: false);
    FocusScope.of(context).unfocus();
    setState(() {
      //para la comprobacion de los textfield
      emailVacio = controladorEmail.text.isEmpty;
      numVacio = controladorNumero.text.isEmpty;
      //logitud del numero
      longNum = controladorNumero.text.toString().length;
      //reseteo de los comprabadores
      numMal = false;
      emailMal = false;
      cargando = false;
    });
    if (supplierInfo.phone.length >= 14) {
      numMal = true;
    }
    if (!controladorEmail.text.contains('@')) {
      setState(() {
        //si el email no contiene la @ no es correcto
        //devuelve un true para los comprobadores
        emailMal = true;
      });
    } else if (!controladorEmail.text.contains('.')) {
      setState(() {
        //si el email no contiene . no es correcto
        //devuelve un true para los comprobadores
        emailMal = true;
      });
    } else {
      final loginOk =
          await login(controladorEmail.text.trim(), supplierInfo.phone);
      setState(() {
        cargando = true;
      });
      if (loginOk) {
        setState(() {
          cargando = false;
          supplierInfo.mail = controladorEmail.text;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const ConfirmarCodigo()));
      } else {
        mostrarAlerta(
            context, 'Inicio de sesión incorrecto', 'Revisa los credenciales');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final supplierInfo = Provider.of<SupplierInfo>(context);
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                //container de foto logo
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Image(
                  image: AssetImage('logo.png'),
                  height: double.maxFinite,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              width: 400,
              child: Column(
                children: [
                  SizedBox(
                    //email
                    child: TextField(
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      controller: controladorEmail,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      cursorColor: const Color(0xff0a1699),
                      decoration: InputDecoration(
                          prefixIcon: emailVacio
                              ? const Icon(Icons.highlight_off_outlined,
                                  color: Colors.red)
                              : const Icon(Icons.mail_outline_rounded,
                                  color: Color(0xff0a1699)),
                          hintText: 'Correo electrónico',
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (countryCode == '')
                      ? CircularProgressIndicator()
                      : IntlPhoneField(
                          languageCode: 'ES',
                          initialCountryCode: countryCode,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Número',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: controladorNumero,
                          onChanged: (phone) {
                            supplierInfo.phone = phone.completeNumber;
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 45,
                    width: 220,
                    child: ElevatedButton(
                      focusNode: _focusNode,
                      onPressed: authService.autenticando
                          ? () {}
                          : () => _handleButtonPress(),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff0a1699)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Solicitar código',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //si cualquiera de los dos textfield esta vacio a la hora de tocar el boton, te enseña el mensaje
                  emailVacio || numVacio
                      ? const Text(
                          'Rellena los campos',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      : emailMal //si el fomarto del email no es correcto
                          ? const Text(
                              'El formato del email no es correcto',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )
                          : numMal
                              ? const Text('El número es demasiado largo',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ))
                              : Container()
                ],
              ),
            ),
          ]),
    ));
  }

  Future<bool> login(String mail, String phone) async {
    final supplierInfo = Provider.of<SupplierInfo>(context, listen: false);
    final data = {
      'mail': mail,
      'phone': phone,
    };

    final Uri uri = Uri.parse('${Enviroment.apiUrl}/supplier_login/');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    try {
      if (resp.statusCode.toString() == '200' &&
          resp.body.toString() != 'null') {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        supplierInfo.token = data['token'];
        supplierInfo.cif = data['cif'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String> fetchCountryCode() async {
    final supplierInfo = Provider.of<SupplierInfo>(context, listen: false);
    final url = Uri.parse('https://freeipapi.com/api/json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      supplierInfo.countryCode = data['countryCode'];
      return data['countryCode'];
    } else {
      return 'ES';
    }
  }
}
