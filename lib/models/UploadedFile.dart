// To parse this JSON data, do
//
//     final uploadedFile = uploadedFileFromJson(jsonString);

import 'dart:convert';

UploadedFile uploadedFileFromJson(String str) => UploadedFile.fromJson(json.decode(str));

String uploadedFileToJson(UploadedFile data) => json.encode(data.toJson());

class UploadedFile {
    String cif;
    String hash;
    int size;
    String fichero;
    String token;
    String invoice;
    int invoiceMonth;
    int invoiceYear;
    double invoiceAmount;
    int invoiceTax;

    UploadedFile({
        required this.cif,
        required this.hash,
        required this.size,
        required this.fichero,
        required this.token,
        required this.invoice,
        required this.invoiceMonth,
        required this.invoiceYear,
        required this.invoiceAmount,
        required this.invoiceTax,
    });

    factory UploadedFile.fromJson(Map<String, dynamic> json) => UploadedFile(
        cif: json["cif"],
        hash: json["hash"],
        size: json["size"],
        fichero: json["fichero"],
        token: json["token"],
        invoice: json["invoice"],
        invoiceMonth: json["invoice_month"],
        invoiceYear: json["invoice_year"],
        invoiceAmount: json["invoice_amount"],
        invoiceTax: json["invoice_tax"],
    );

    Map<String, dynamic> toJson() => {
        "cif": cif,
        "hash": hash,
        "size": size,
        "fichero": fichero,
        "token": token,
        "invoice": invoice,
        "invoice_month": invoiceMonth,
        "invoice_year": invoiceYear,
        "invoice_amount": invoiceAmount,
        "invoice_tax": invoiceTax,
    };
}
