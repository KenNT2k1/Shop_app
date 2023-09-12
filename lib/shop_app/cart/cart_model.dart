import 'package:flutter_imic05/shop_app/product/product_model.dart';

class CartModel {
  String? id;
  double? totalPrice;
  List<ProductModel>? products;

  CartModel({this.id, this.totalPrice, this.products});

  factory CartModel.fromJson(Map json) {
    return CartModel(
      id: json['id'] as String?,
      totalPrice: json['totalPrice'] as double?,
      products: List<ProductModel>.from(
        json['products']?.map((e) => ProductModel.fromMap(e))?.toList(),
      ),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'products': products?.map((e) => e.toMap()).toList(),
    };
  }
}
