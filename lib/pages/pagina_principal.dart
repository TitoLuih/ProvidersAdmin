import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/global/enviroment.dart';
import 'package:proyecto_fct_facturas/models/dropped_file.dart';
import 'package:proyecto_fct_facturas/models/getUploadedFiles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_fct_facturas/pages/pedidos_page.dart';
import 'package:proyecto_fct_facturas/providers/documents_providers.dart';
import 'package:proyecto_fct_facturas/providers/supplier_info.dart';
import 'package:proyecto_fct_facturas/widgets/dropped_image_widget.dart';
import 'package:proyecto_fct_facturas/widgets/dropzone_widget.dart';
import 'package:http/http.dart' as http;

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({
    super.key,
  });

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  //declaracion de variables
  String codDoc = '';
  late DateTime fecha;
  String hash = '';
  String cifDentro = '';
  int size = 0;
  String fichero = '';

  String pruebaURL = '';

  bool enviado = false;
  bool highlighted1 = false;
  bool fallo = false;

  bool fileUploaded = false;
  bool fileSent = false;

  late DropzoneViewController controller1;
  late DropzoneViewController controller2;

  DroppedFile? file;

  Future<List<getDoc>> loadedData(String cif, String token) async {
    List<getDoc> orders = [];
    final data = {
      'cif': cif,
      'token': token,
    };
    final Uri uri =
        Uri.parse('${Enviroment.apiUrl}/get_uploaded_supplier_invoice/');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    try {
      if (resp.statusCode.toString() == '200' &&
          resp.body.toString() != 'null') {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        final datos = GetUploadedFile.fromJson(data);

        for (var i = 0; i < datos.docs.length; i++) {
          codDoc = datos.docs[i].codDoc;
          fecha = datos.docs[i].fecha;
          cifDentro = datos.docs[i].cif;
          hash = datos.docs[i].hash;
          size = datos.docs[i].size;
          fichero = datos.docs[i].fichero;
          // invoice = datos.docs[i].invoice;
          // invoiceMonth = datos.docs[i].invoiceMonth;
          // invoiceYear = datos.docs[i].invoiceYear;
          // invoiceAmount = datos.docs[i].invoiceAmount;
          // invoiceTax = datos.docs[i].invoiceTax;

          orders.add(getDoc(
            codDoc: codDoc,
            fecha: fecha,
            cif: cifDentro,
            hash: hash,
            size: size,
            fichero: fichero,
          ));
          // pedidos.add(UploadedFile(
          //     cif: cifDentro,
          //     hash: hash,
          //     size: size,
          //     fichero: fichero,
          //     token : token,
          //     invoice: invoice,
          //     invoiceMonth: ,
          //     invoiceYear :invoiceYear,
          //     invoiceAmount : invoiceAmount,
          //     invoiceTax : invoiceTax,

          //     ));
        }
      } else {
      }
    } catch (e) {
      throw Exception('error conexion');
    }
    return orders;
  }

  @override
  void initState() {
    final supplierInfo = Provider.of<SupplierInfo>(context, listen: false);
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      documentsProvider.loading = true;
      loadedData(supplierInfo.cif, supplierInfo.token).then((snapshot) {
        documentsProvider.orders = snapshot;
        documentsProvider.loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: true);

    final supplierInfo = Provider.of<SupplierInfo>(context, listen: true);

    return Scaffold(
      body: Row(
        children: <Widget>[
          //fila izquierda
          SizedBox(
            width: 450,
            child: Column(
              children: <Widget>[
                Container(
                  //parte azul de arriba
                  decoration: const BoxDecoration(
                    color: Color(0xff0a1699),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(supplierInfo.cif,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(supplierInfo.phone,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(supplierInfo.mail,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text('ES12 1234 1234 12 1234567890',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  //lista de abajo
                  child: (!documentsProvider.loading)
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(10),
                          itemCount: documentsProvider.orders.length,
                          itemBuilder: (context, i) =>
                              pedidosTile(documentsProvider.orders, i),
                        )
                      : const Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator()),
                            ),
                          ],
                        ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              //container para el color
              color: Colors.grey.shade300,
              child: Center(
                child: Column(
                  //columna para el drop
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DroppedFileWidget(file: file), //informacion del archivo
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      //widget de donde cae el fichero
                      alignment: Alignment.center,
                      height: 520,
                      width: 670,
                      child: DropzoneWidget(
                        onDroppedFile: (file) => setState(() {
                          this.file = file;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile pedidosTile(List<getDoc> pedidos, int index) {
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: false);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(pedidos[index].fecha);
    return ListTile(
      enabled: true,
      hoverColor: Colors.grey.shade100,
      iconColor: Colors.black,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      textColor: Colors.black,
      leading: const FaIcon(FontAwesomeIcons.filePdf),
      title: Text(
        pedidos[index].fichero.substring(37),
        style: const TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Fecha de subida: $formatted',
        style: const TextStyle(
            fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        documentsProvider.nombreFichero = pedidos[index].fichero.substring(37);
        documentsProvider.fichero = pedidos[index].fichero;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PedidosPage()),
        );
      },
    );
  }
}
