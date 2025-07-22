// To parse this JSON data, do
//
//     final getUploadedFile = getUploadedFileFromJson(jsonString);

import 'dart:convert';

GetUploadedFile getUploadedFileFromJson(String str) => GetUploadedFile.fromJson(json.decode(str));

String getUploadedFileToJson(GetUploadedFile data) => json.encode(data.toJson());

class GetUploadedFile {
    List<getDoc> docs;

    GetUploadedFile({
        required this.docs,
    });

    factory GetUploadedFile.fromJson(Map<String, dynamic> json) => GetUploadedFile(
        docs: List<getDoc>.from(json["docs"].map((x) => getDoc.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
    };
}

class getDoc {
    String codDoc;
    DateTime fecha;
    String cif;
    String hash;
    int size;
    String fichero;

    getDoc({
        required this.codDoc,
        required this.fecha,
        required this.cif,
        required this.hash,
        required this.size,
        required this.fichero,
    });

    factory getDoc.fromJson(Map<String, dynamic> json) => getDoc(
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
