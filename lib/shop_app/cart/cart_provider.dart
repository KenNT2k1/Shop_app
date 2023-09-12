import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_imic05/shop_app/auth/auth_model.dart';
import 'package:flutter_imic05/shop_app/cart/cart_model.dart';
import 'package:flutter_imic05/shop_app/product/product_model.dart';

class CartProvider extends ChangeNotifier {
  AuthModel? authModel;
  final Dio dio;
  final String baseUrl;

  CartProvider({required this.dio, required this.baseUrl});

  void updateAuthModel(AuthModel model) {
    authModel = model;
  }

  final products = List<ProductModel>.empty(growable: true);

  void clearProducts() {
    products.clear();
    notifyListeners();
  }

  void addItemToCart(ProductModel model) {
    final index = products.indexWhere((element) => element.id == model.id);
    if (index == -1) {
      products.add(model);
    } else {
      products[index] = products[index].copyWith(
        quantity: (products[index].quantity ?? 0) + 1,
      );
    }
    notifyListeners();
  }

  void decreeQuantity(ProductModel model) {
    final index = products.indexWhere((element) => element.id == model.id);
    if (index != -1) {
      if ((products[index].quantity ?? 0) - 1 <= 0) {
        products.removeAt(index);
      } else {
        products[index] = products[index].copyWith(
          quantity: (products[index].quantity ?? 0) - 1,
        );
      }
    }
    notifyListeners();
  }

  Future<void> saveOrderToServer() async {
    final cart = CartModel();
    cart.id = DateTime.now().microsecondsSinceEpoch.toRadixString(10);
    cart.products = products;
    cart.totalPrice = totalPrice;

    final result = await dio.post(
        '$baseUrl/orders/${authModel!.localId!}.json',
        data: cart.toJson());

    if (result.statusCode != HttpStatus.ok) {
      throw Exception('Failed to save order');
    }
  }

  Future<List<CartModel>> getOrderFromServer() async {
    final response = await dio.get(
      '$baseUrl/orders/${authModel!.localId!}.json',
    );
    if (response.statusCode == HttpStatus.ok) {
      final carts = (response.data as Map)
          .entries
          .map((e) => CartModel.fromJson(e.value))
          .toList();
      return carts;
    }
    throw HttpException(response.data);
  }

  int get totalItems => products.fold(
      0, (previousValue, element) => previousValue + element.quantity!);

  double get totalPrice => products.fold(
      0.0,
      (previousValue, element) =>
          previousValue + element.price! * element.quantity!);
}
