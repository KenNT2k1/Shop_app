import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_imic05/shop_app/auth/auth_model.dart';
import 'package:flutter_imic05/shop_app/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this.dio, required this.baseUrl});
  final Dio dio;
  final String baseUrl;

  AuthModel? authModel;

  Future<void> register(
      {String segment = 'signUp',
      required String userName,
      required String password}) {
    return _auth(userName: userName, password: password);
  }

  Future<void> login(
      {String segment = 'signUp',
      required String userName,
      required String password}) {
    return _auth(
        segment: 'signInWithPassword', userName: userName, password: password);
  }

  Future<void> _auth(
      {String segment = 'signUp',
      required String userName,
      required String password}) async {
    final data = jsonEncode(
        {"email": userName, "password": password, "returnSecureToken": true});

    final response = await dio.post(
      '$baseUrl/accounts:$segment?key=$authKey',
      data: data,
    );
    if (response.statusCode == 200) {
      authModel = AuthModel.fromJson(response.data);
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          'auth', jsonEncode(authModel!.toJson()));
    } else {
      throw HttpException(response.data);
    }
  }

  Future<bool> isAuthenticated() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final authString = sharedPreferences.getString('auth');
    if (authString == null) {
      return false;
    }
    try {
      authModel = AuthModel.fromJson(jsonDecode(authString));
    } catch (e) {
      return false;
    }
    if (authModel == null ||
        (authModel?.idToken?.isEmpty ?? true) ||
        authModel?.expiredAt == null) {
      return false;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now > authModel!.expiredAt!) {
      return false;
    }
    return true;
  }
}
