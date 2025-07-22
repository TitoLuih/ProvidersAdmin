// To parse this JSON data, do
//
//     final proveedores = proveedoresFromJson(jsonString);

import 'dart:convert';

Proveedores proveedoresFromJson(String str) => Proveedores.fromJson(json.decode(str));

String proveedoresToJson(Proveedores data) => json.encode(data.toJson());

class Proveedores {
    String nif;
    String nombre;
    String telefono;
    String email;
    String iban;

    Proveedores({
        required this.nif,
        required this.nombre,
        required this.telefono,
        required this.email,
        required this.iban,
    });

    factory Proveedores.fromJson(Map<String, dynamic> json) => Proveedores(
        nif: json["NIF"],
        nombre: json["nombre"],
        telefono: json["telefono"],
        email: json["email"],
        iban: json["iban"],
    );

    Map<String, dynamic> toJson() => {
        "NIF": nif,
        "nombre": nombre,
        "telefono": telefono,
        "email": email,
        "iban": iban,
    };
}
