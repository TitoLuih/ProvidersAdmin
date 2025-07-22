// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:azblob/azblob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_fct_facturas/models/dropped_file.dart';

import 'package:proyecto_fct_facturas/providers/documents_providers.dart';
import 'package:proyecto_fct_facturas/widgets/form_invoice.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({
    super.key,
    required this.onDroppedFile,
  });

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  //declaracion del controlador
  late DropzoneViewController controller;
  //declaracion de variables
  bool isHighlighted = false;
  bool uploadError = false;
  bool notPDF = false;
  bool tooBig = false;
  bool left = true;
  bool fileUploaded = false;
  bool fileSent = false;

  var storage = AzureStorage.parse(
      'Conection.dummy.api');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: true);


    //variables de los colores
    //color del fondo
    var colorBackground = isHighlighted ? Colors.blue : Colors.blueGrey;

    //color del boton
    var colorButton =
        isHighlighted ? Colors.blue.shade300 : Colors.blueGrey.shade300;

    //si falla la subida, por que no sea pdf o pq sea muy grande, se cambian los colores a rojo
    if (notPDF || tooBig || uploadError) {
      colorBackground = Colors.red;
      colorButton = Colors.red.shade300;
    }

    return (documentsProvider.fileUploaded)
        ? const FormInvoice()
        : Container(
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                DropzoneView(
                  onCreated: (controller) => this.controller = controller,
                  onDrop: (value) => acceptFile(value),
                  mime: const ['application/pdf'], //para que solo admita pdf
                  //cuando pasa por arriba cambia los parametros
                  onHover: () => setState(() {
                    isHighlighted = true;
                    fileUploaded = false;
                    notPDF = false;
                    tooBig = false;
                    left = false;
                  }),
                  //cuando sale del recuadro cambia
                  onLeave: () => setState(() {
                    isHighlighted = false;
                    fileUploaded = false;
                    notPDF = false;
                    tooBig = false;
                    left = true;
                  }), //cuando algo falla, o porque no se puede por tamaño o formato
                  onDropInvalid: (value) {
                    setState(() {
                      fileUploaded = false;
                      isHighlighted = false;
                      notPDF = true;
                    });
                  },
                ),
                Center(
                    child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      documentsProvider.fileUploaded
                          ? const ArchivoCorrecto()
                          : isHighlighted
                              ? const HoverTrue()
                              : const HoverFalse(),
                      isHighlighted
                          ? Container()
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  backgroundColor: colorButton),
                              icon: const Icon(
                                Icons.search,
                                size: 35,
                                color: Colors.white70,
                              ),
                              label: const Text('Elige el archivo',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 20)),
                              onPressed: () async {
                                setState(() {
                                  fileUploaded = false;
                                  left = true;
                                  notPDF = false;
                                  tooBig = false;
                                });
                                final events = await controller.pickFiles(
                                  multiple: false,
                                  mime: const ['application/pdf'],
                                );
                                acceptFile(events.first);
                              },
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      notPDF
                          ? const Text(
                              'Formato no soportado, recuerda selecciona un PDF',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white70))
                          : tooBig
                              ? const Text(
                                  'Demasiado grande, tamaño máximo 10MB',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white70))
                              : uploadError
                                  ? const Text(
                                      'Ha habido un fallo, intentalo más tarde',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white70))
                                  : Container(),
                    ],
                  ),
                )),
              ],
            ),
          );
  }

  Future acceptFile(dynamic event) async {
    final documentsProvider =
        Provider.of<DocumentsProvider>(context, listen: false);

    final name = event.name;
    final mime = await controller.getFileMIME(event);
    final size = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    final hash = controller.hashCode;
    final bytes = await controller.getFileData(event);

    documentsProvider.name = name;
    documentsProvider.hash = hash.toString();
    documentsProvider.size = size;
    documentsProvider.bytes = bytes;

    final droppedFile = DroppedFile(
      url: url,
      name: name,
      mime: mime,
      size: size,
      hash: hash,
    );


    if (mime != 'application/pdf') {
      setState(() {
        notPDF = true;
      });
    } else if (size >= 10485760) {
      setState(() {
        tooBig = true;
        isHighlighted = false;
      });
    } else {
      try {
        widget.onDroppedFile(droppedFile);
        documentsProvider.url = droppedFile.url;
        documentsProvider.mime = droppedFile.mime;
        documentsProvider.size = droppedFile.hash;
        setState(() {
          notPDF = false;
          left = false;
          isHighlighted = false;
          tooBig = false;
          fileUploaded = false;
          uploadError = false;
          documentsProvider.fileUploaded = true;
        });
      } catch (e) {
        setState(() {
          uploadError = true;
        });
      }
        
      setState(() {
        isHighlighted = false;
      });
    }
  }
}

class ArchivoCorrecto extends StatelessWidget {
  const ArchivoCorrecto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.check_rounded, size: 200, color: Colors.white),
        SizedBox(
          height: 20,
        ),
        Text('Archivo correcto',
            style: TextStyle(fontSize: 20, color: Colors.white60)),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class ArchivoEnviado extends StatelessWidget {
  const ArchivoEnviado({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.check_rounded, size: 200, color: Colors.white),
        SizedBox(
          height: 20,
        ),
        Text('Archivo subido correctamente',
            style: TextStyle(fontSize: 20, color: Colors.white60)),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class HoverFalse extends StatelessWidget {
  const HoverFalse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FaIcon(FontAwesomeIcons.cloudArrowDown, color: Colors.white, size: 100),
        Text('Suelta el archivo aquí',
            style: TextStyle(fontSize: 45, color: Colors.white)),
        SizedBox(
          height: 10,
        ),
        Text('Solo archivos PDF',
            style: TextStyle(
                color: Colors.white60,
                fontSize: 25,
                fontWeight: FontWeight.w200)),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

class HoverTrue extends StatelessWidget {
  const HoverTrue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FaIcon(FontAwesomeIcons.cloudArrowDown, color: Colors.white, size: 280),
        SizedBox(
          height: 10,
        ),
        Text(
          'Dejalo caer aquí',
          style: TextStyle(color: Colors.white60, fontSize: 25),
        )
      ],
    );
  }
}
