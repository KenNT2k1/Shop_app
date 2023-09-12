import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class ProductModel {
  final String? id;
  final String? title;
  final double? price;
  final String? description;
  final String? imageUrl;
  final int? quantity;

  const ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.imageUrl,
    this.quantity,
  });

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title, price: $price, description: $description, imageUrl: $imageUrl, quantity: $quantity)';
  }

  factory ProductModel.fromMap(Map<String, dynamic> data) => ProductModel(
        id: data['id'] as String?,
        title: data['title'] as String?,
        price: data['price'] as double?,
        description: data['description'] as String?,
        imageUrl: data['imageUrl'] as String?,
        quantity: data['quantity'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductModel].
  factory ProductModel.fromJson(String data) {
    return ProductModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductModel copyWith({
    String? id,
    String? title,
    double? price,
    String? description,
    String? imageUrl,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ProductModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      quantity.hashCode;
}
