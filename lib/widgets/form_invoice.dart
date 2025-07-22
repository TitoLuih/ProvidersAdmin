import 'dart:convert';

import 'package:azblob/azblob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/global/enviroment.dart';
import 'package:proyecto_fct_facturas/models/UploadedFile.dart';
import 'package:proyecto_fct_facturas/providers/documents_providers.dart';
import 'package:proyecto_fct_facturas/providers/supplier_info.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FormInvoice extends StatefulWidget {
  const FormInvoice({
    super.key,
  });

  @override
  State<FormInvoice> createState() => _FormInvoiceState();
}

const List<String> meses = <String>[
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre'
];

List<String> years = <String>[
  (DateTime.now().year - 1).toString(),
  (DateTime.now().year).toString(),
  (DateTime.now().year + 1).toString(),
];

class _FormInvoiceState extends State<FormInvoice> {
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final amountController = TextEditingController();
  final invoiceController = TextEditingController();
  final taxController = TextEditingController();

  String dropdownValue = meses.first;

  String dropdownValueYears = years.first;

  int month = 0;
  int year = 0;

  bool amountValid = true;

  bool invoiceEmpty = false;
  bool amountEmpty = false;
  bool taxEmpty = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: true);
    final supplierInfo = Provider.of<SupplierInfo>(context, listen: false);

    return Column(
      children: [
        SizedBox(
          child: DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            // icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.black87, fontSize: 18),
            underline: Container(
              height: 2,
            ),
            borderRadius: BorderRadius.circular(15),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: meses.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: DropdownButton<String>(
            alignment: Alignment.center,
            value: dropdownValueYears,
            // icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            isExpanded: true,
            style: const TextStyle(color: Colors.black87, fontSize: 18),
            underline: Container(
              height: 2,
              alignment: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(15),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValueYears = value!;
              });
            },
            items: years.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          //nPedido
          autofocus: true,
          controller: invoiceController,
          textAlign: TextAlign.center,
          cursorColor: const Color(0xff0a1699),
          decoration: const InputDecoration(
              hintText: 'Numero de factura',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          //importe total
          autofocus: true,
          controller: amountController,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
          ],
          cursorColor: const Color(0xff0a1699),
          decoration: const InputDecoration(
              hintText: 'Cantidad total',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          //IVA
          autofocus: true,
          controller: taxController,
          maxLength: 2,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          cursorColor: const Color(0xff0a1699),
          decoration: const InputDecoration(
              hintText: 'IVA',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 45,
          width: 220,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                invoiceEmpty = false;
                amountEmpty = false;
                month = 0;
                taxEmpty = false;

                if (amountController.text.isEmpty) {
                  amountEmpty = true;
                }
                if (taxController.text.isEmpty) {
                  taxEmpty = true;
                }

                year = int.parse(dropdownValueYears);
                month = comprobacionMes(dropdownValue);
              });
              if (month > 0 && !invoiceEmpty && !amountEmpty && !taxEmpty) {
                var storage = AzureStorage.parse(Enviroment.azureConnection);
                var uid = const Uuid();
                String id = '${uid.v1().toString()}_${documentsProvider.name}';
                await storage.putBlob('/erp-facturas/$id',
                    contentType: '[application/pdf]',
                    bodyBytes: documentsProvider.bytes);

                final data = {
                  'cif': supplierInfo.cif,
                  'hash': documentsProvider.hash,
                  'size': documentsProvider.size,
                  'fichero': id,
                  'token': supplierInfo.token
                };

                month = comprobacionMes(dropdownValue);
                final Uri uri =
                    Uri.parse('${Enviroment.apiUrl}/upload_supplier_invoice/');

                final resp = await http.post(uri,
                    body: jsonEncode(data),
                    headers: {'Content-Type': 'application/json'});

                try {
                  if (resp.statusCode.toString() == '200' &&
                      resp.body.toString() != 'null') {
                    documentsProvider.addDocument(UploadedFile(
                        cif: supplierInfo.cif,
                        hash: documentsProvider.hash,
                        size: documentsProvider.size,
                        fichero: documentsProvider.name,
                        token: supplierInfo.token,
                        //parametros que son introducidos en este widget
                        invoice: invoiceController.text,
                        invoiceMonth: month,
                        invoiceYear: year,
                        invoiceAmount: double.parse(amountController.text),
                        invoiceTax: int.parse(taxController.text)));

                    setState(() {
                      documentsProvider.fileUploaded = false;
                    });
                  } else {
                    setState(() {
                      documentsProvider.uploadError = true;
                    });
                  }
                } catch (e) {
                  throw Exception('Error al subir el archivo');
                }
                setState(() {
                  documentsProvider.fileUploaded = false;
                });
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xff0a1699)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: const Text(
              'Enviar factura',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 20),
        invoiceEmpty
            ? const Text(
                'El numero de pedido esta vacío',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              )
            : amountEmpty
                ? const Text(
                    'La cantidad esta vacía',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  )
                : taxEmpty
                    ? const Text(
                        'El iva es obligatorio',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      )
                    : Container()
      ],
    );
  }
}

bool equalsIgnoreCase(String? string1, String? string2) {
  return string1?.toLowerCase() == string2?.toLowerCase();
}

int comprobacionMes(String mes) {
  int month = 0;
  if (equalsIgnoreCase(mes, 'enero')) {
    month = 01;
  } else if (equalsIgnoreCase(mes, 'febrero')) {
    month = 02;
  } else if (equalsIgnoreCase(mes, 'marzo')) {
    month = 03;
  } else if (equalsIgnoreCase(mes, 'abril')) {
    month = 04;
  } else if (equalsIgnoreCase(mes, 'mayo')) {
    month = 05;
  } else if (equalsIgnoreCase(mes, 'junio')) {
    month = 06;
  } else if (equalsIgnoreCase(mes, 'julio')) {
    month = 07;
  } else if (equalsIgnoreCase(mes, 'agosto')) {
    month = 08;
  } else if (equalsIgnoreCase(mes, 'septiembre')) {
    month = 09;
  } else if (equalsIgnoreCase(mes, 'octubre')) {
    month = 10;
  } else if (equalsIgnoreCase(mes, 'noviembre')) {
    month = 11;
  } else if (equalsIgnoreCase(mes, 'diciembre')) {
    month = 12;
  }
  return month;
}
