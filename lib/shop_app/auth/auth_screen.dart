import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';

enum FormType { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FormType _formType = FormType.login;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple.withAlpha(220),
                    Colors.orange.withAlpha(150)
                  ]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Transform.rotate(
                angle: 3.14 / -15,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text(
                      'MyShop',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'E-Mail'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(hintText: 'Password'),
                      obscureText: true,
                    ),
                    AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _formType == FormType.login ? 0 : 1,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: SizedBox(
                            height: _formType == FormType.login ? 0 : null,
                            child: const TextField(
                              decoration:
                                  InputDecoration(hintText: 'Re-Password'),
                              obscureText: true,
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Future? auth;
                        if (_formType == FormType.register) {
                          auth = context.read<AuthProvider>().register(
                              userName: emailController.text,
                              password: passwordController.text);
                        } else {
                          auth = context.read<AuthProvider>().login(
                              userName: emailController.text,
                              password: passwordController.text);
                        }
                        auth
                            .then((value) => Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const ShopHomeScreen(),
                                )))
                            .catchError((e) {
                          var message =
                              'Have an error, please try again later.';
                          if (e is DioError) {
                            final code = e.response?.data?['error']['message'];
                            if (code == 'EMAIL_NOT_FOUND' ||
                                code == 'INVALID_EMAIL' ||
                                code == 'INVALID_PASSWORD') {
                              message =
                                  'Your email or password is invalid, please try again later';
                            } else if (code == 'USER_DISABLED') {
                              message =
                                  'Your user was disabled, please contact the administrator';
                            } else if (code == 'EMAIL_EXISTS') {
                              message =
                                  'Your email address is already in use. Please try again later';
                            }
                          }
                          ScaffoldMessenger.maybeOf(context)
                              ?.showSnackBar(SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.red))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            _formType == FormType.login ? 'Login' : 'Register'),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (_formType == FormType.login) {
                              _formType = FormType.register;
                            } else {
                              _formType = FormType.login;
                            }
                          });
                        },
                        child: Text(_formType == FormType.login
                            ? 'Register'
                            : 'Login')),
                  ],
                ),
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
