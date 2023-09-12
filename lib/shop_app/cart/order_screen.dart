import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/cart/cart_model.dart';
import 'package:flutter_imic05/shop_app/cart/cart_provider.dart';
import 'package:flutter_imic05/shop_app/widget/app_drawer.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routerName = "order_screen";
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<CartModel>> _future;
  @override
  void initState() {
    _future = context.read<CartProvider>().getOrderFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Order screen')),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Order ${snapshot.data![index].id}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total price: \$${snapshot.data![index].totalPrice}',
                      ),
                      ...snapshot.data![index].products!
                          .map((e) => [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(e.title ?? '--'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('Quality: ${e.quantity}'),
                                Text('Price: \$${e.price}'),
                              ])
                          .expand((element) => element),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshot.data!.length);
          }
          return const CircularProgressIndicator();
        },
        future: _future,
      ),
    );
  }
}
