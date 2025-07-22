// To parse this JSON data, do
//
//     final documento = documentoFromJson(jsonString);

import 'dart:convert';

Documento documentoFromJson(String str) => Documento.fromJson(json.decode(str));

String documentoToJson(Documento data) => json.encode(data.toJson());

class Documento {
    List<Doc> docs;

    Documento({
        required this.docs,
    });

    factory Documento.fromJson(Map<String, dynamic> json) => Documento(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
    };
}

class Doc {
    String codDoc;
    DateTime fecha;
    String cif;
    String hash;
    int size;
    String fichero;

    Doc({
        required this.codDoc,
        required this.fecha,
        required this.cif,
        required this.hash,
        required this.size,
        required this.fichero,
    });

    factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        codDoc: json["cod_doc"],
        fecha: DateTime.parse(json["fecha"]),
        cif: json["cif"],
        hash: json["hash"],
        size: json["size"],
        fichero: json["fichero"],
    );

    Map<String, dynamic> toJson() => {
        "cod_doc": codDoc,
        "fecha": fecha.toIso8601String(),
        "cif": cif,
        "hash": hash,
        "size": size,
        "fichero": fichero,
    };
}
