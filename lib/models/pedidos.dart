// To parse this JSON data, do
//
//     final pedidos = pedidosFromJson(jsonString);

import 'dart:convert';

Pedidos pedidosFromJson(String str) => Pedidos.fromJson(json.decode(str));

String pedidosToJson(Pedidos data) => json.encode(data.toJson());

class Pedidos {
  String id;
  String fecha;
  double precioTotal;
  bool entregado;

  Pedidos({
    required this.id,
    required this.fecha,
    required this.precioTotal,
    required this.entregado,
  });

  factory Pedidos.fromJson(Map<String, dynamic> json) => Pedidos(
        id: json["id"],
        fecha: json["fecha"],
        precioTotal: json["precioTotal"]?.toDouble(),
        entregado: json["entregado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "precioTotal": precioTotal,
        "entregado": entregado,
      };
}
