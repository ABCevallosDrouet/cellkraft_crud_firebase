
import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? id;
  String? titulo;
  double? valor;
  bool disponible = true;
  String? fotoUrl;

  ProductModel({
    this.id,
    this.titulo,
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    titulo: json["titulo"],
    valor: json["valor"]?.toDouble(),
    disponible: json["disponible"],
    fotoUrl: json["fotoURL"],
  );

  Map<String, dynamic> toJson() => {
    "titulo": titulo,
    "valor": valor,
    "disponible": disponible,
    "fotoURL": fotoUrl,
  };
}