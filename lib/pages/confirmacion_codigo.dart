import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/pages/pagina_principal.dart';
import 'package:proyecto_fct_facturas/providers/supplier_info.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ConfirmarCodigo extends StatefulWidget {
  const ConfirmarCodigo({
    super.key,
  });

  @override
  State<ConfirmarCodigo> createState() => _ConfirmarCodigoState();
}

class _ConfirmarCodigoState extends State<ConfirmarCodigo> with CodeAutoFill {
  String _code = "";
  String? appSignature;
  String? otpCode;

  final controladorCodigo = TextEditingController();

  bool codigoCorrecto = false;

  bool falloLongitud = false;
  bool invalidCode = false;
  bool codigoVacio = false;

  int longCode = 0;
 @override
  void codeUpdated() {
    setState(() {
      otpCode = _code;
    });
  }

  @override
  void initState() {
    super.initState();
    CodeAutoFill;
    SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supplierInfo = Provider.of<SupplierInfo>(context, listen: true);
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //container de foto logo
              height: 200,
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: const Image(
                image: AssetImage('logo.png'),
                height: double.maxFinite,
              ),
            ),
            SizedBox(
              height: 300,
              width: 400,
              child: Column(
                children: [
                  PinFieldAutoFill(
                    autoFocus: true,
                    decoration: UnderlineDecoration(
                      textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      colorBuilder:
                          FixedColorBuilder(Colors.black.withOpacity(0.3)),
                    ),
                    currentCode: _code,
                    controller: controladorCodigo,
                    onCodeSubmitted: (code) {},
                    onCodeChanged: (code) {
                      if (code!.length == 6) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          codigoVacio = controladorCodigo.text.isEmpty;
                          longCode = controladorCodigo.text.length;
                        });
                        if (longCode < 6) {
                          setState(() {
                            falloLongitud = true;
                          });
                        } else if (!codigoVacio &&
                            controladorCodigo.text.toString() ==
                                supplierInfo.token) {
                          setState(() {
                            codigoVacio = false;
                            falloLongitud = false;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaginaPrincipal()),
                          );
                        } else if (controladorCodigo.toString() !=
                            supplierInfo.token) {
                          setState(() {
                            codigoVacio = false;
                            falloLongitud = false;
                            invalidCode = true;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff0a1699)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Acceder',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  codigoVacio
                      ? const Text(
                          'Rellena el campo',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      : falloLongitud
                          ? const Text(
                              'El numero no es lo suficientemente largo',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )
                          : invalidCode
                              ? const Text(
                                  'El código es incorrecto',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )
                              : Container()
                ],
              ),
            ),
          ]),
    ));
  }
}
