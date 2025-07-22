import 'dart:convert';

Articulos articulosFromJson(String str) => Articulos.fromJson(json.decode(str));

String articulosToJson(Articulos data) => json.encode(data.toJson());

class Articulos {
    String id;
    String nombre;
    int cantidad;
    double precioConIva;
    double precioSinIva;

    Articulos({
        required this.id,
        required this.nombre,
        required this.cantidad,
        required this.precioConIva,
        required this.precioSinIva,
    });

    factory Articulos.fromJson(Map<String, dynamic> json) => Articulos(
        id: json["id"],
        nombre: json["nombre"],
        cantidad: json["cantidad"],
        precioConIva: json["precioConIva"]?.toDouble(),
        precioSinIva: json["precioSinIva"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "cantidad": cantidad,
        "precioConIva": precioConIva,
        "precioSinIva": precioSinIva,
    };
}
