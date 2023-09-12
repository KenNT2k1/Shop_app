// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_imic05/shop_app/auth/auth_model.dart';
import 'package:flutter_imic05/shop_app/product/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  AuthModel? authModel;
  final Dio dio;
  final String baseUrl;

  ProductProvider({required this.dio, required this.baseUrl});

  void updateAuthModel(AuthModel model) {
    authModel = model;
  }

  Future<List<ProductModel>> getProductsFromServer() async {
    try {
      final response =
          await dio.get('$baseUrl/products.json');
      if (response.statusCode == HttpStatus.ok) {
        products = (response.data as Map)
            .entries
            .map((e) => ProductModel.fromMap(e.value))
            .toList();
        return products;
      }
      throw HttpException(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ProductModel> addProductToServer(ProductModel model) async {
    try {
      final response = await dio.post(
        '$baseUrl/products.json',
        data: model.toJson(),
      );
      if (response.statusCode == HttpStatus.ok) {
        return (response.data as Map)
            .entries
            .map((e) => model.copyWith(
                  id: e.key,
                ))
            .first;
      }
      throw HttpException(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void addProduct(ProductModel model) {
    products.add(model);
    notifyListeners();
  }

  Future<ProductModel> updateProductToServer(ProductModel model) async {
    try {
      final response = await dio.put(
        '$baseUrl/products/${model.id}.json',
        data: model.toJson(),
      );
      if (response.statusCode == HttpStatus.ok) {
        return model;
      }
      throw HttpException(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void updateProduct(ProductModel model) {
    products[products.indexWhere((e) => e.id == model.id)] = model;
    notifyListeners();
  }

  Future<ProductModel> deleteProductToServer(ProductModel model) async {
    try {
      final response = await dio
          .delete('$baseUrl/products/${model.id}.json');
      if (response.statusCode == HttpStatus.ok) {
        return model;
      }
      throw HttpException(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void deleteProduct(ProductModel model) {
    products.removeWhere((element) => element.id == model.id);
    notifyListeners();
  }
}
