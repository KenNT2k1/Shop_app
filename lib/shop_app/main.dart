import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/auth/auth_provider.dart';
import 'package:flutter_imic05/shop_app/auth/auth_screen.dart';
import 'package:flutter_imic05/shop_app/cart/cart_provider.dart';
import 'package:flutter_imic05/shop_app/cart/cart_screen.dart';
import 'package:flutter_imic05/shop_app/cart/order_screen.dart';
import 'package:flutter_imic05/shop_app/const.dart';
import 'package:flutter_imic05/shop_app/home/home_screen.dart';
import 'package:flutter_imic05/shop_app/product/edit_product_screen.dart';
import 'package:flutter_imic05/shop_app/product/product_model.dart';
import 'package:flutter_imic05/shop_app/product/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final authString = sharedPreferences.getString('auth');
      if (authString != null) {
        try {
          final authModel = AuthModel.fromJson(jsonDecode(authString));
          if (authModel.idToken != null) {
            // options.headers["Authorization"] =
            //     "Bearer ${authModel.idToken ?? ''}";
            options.queryParameters = {
              ...options.queryParameters,
              'auth': authModel.idToken!
            };
          }
        } catch (e) {
          print(e);
        }
      }
      return handler.next(options);
    },
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider(dio: dio, baseUrl: authUrl)),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider(dio: dio, baseUrl: realtimeDBUrl),
          update: (BuildContext context, value, ProductProvider? previous) {
            return previous!..updateAuthModel(value.authModel!);
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(dio: dio, baseUrl: realtimeDBUrl),
          update: (BuildContext context, value, CartProvider? previous) {
            return previous!..updateAuthModel(value.authModel!);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: FutureBuilder<bool>(
          future: context.read<AuthProvider>().isAuthenticated(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final isAuthenticated = snapshot.data == true;
            return isAuthenticated
                ? const ShopHomeScreen()
                : const AuthScreen();
          }),
      onGenerateRoute: (settings) {
        if (settings.name == ProductListScreen.routerName) {
          return MaterialPageRoute(
            builder: (context) {
              return const ProductListScreen();
            },
          );
        }
        if (settings.name == MyShopScreen.routerName) {
          return MaterialPageRoute(
            builder: (context) {
              return const MyShopScreen();
            },
          );
        }
        if (settings.name == EditProduct.routerName) {
          return MaterialPageRoute(
            builder: (context) {
              return EditProduct(
                product: settings.arguments as ProductModel?,
              );
            },
          );
        }
        if (settings.name == CartScreen.routerName) {
          return MaterialPageRoute(
            builder: (context) {
              return const CartScreen();
            },
          );
        }
        if (settings.name == OrderScreen.routerName) {
          return MaterialPageRoute(
            builder: (context) {
              return const OrderScreen();
            },
          );
        }
        return null;
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('Unknown router with name ${settings.name}'),
          ),
        ),
      ),
    );
  }
}
