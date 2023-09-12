import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/cart/cart_provider.dart';
import 'package:flutter_imic05/shop_app/cart/order_screen.dart';
import 'package:flutter_imic05/shop_app/widget/loading_dialog.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routerName = "cart_provider_screen";
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart screen'),
        actions: [
          IconButton(
            onPressed: () {
              showLoading(context);
              context.read<CartProvider>().saveOrderToServer().then((value) {
                //Hide the loading
                Navigator.pop(context);
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  const SnackBar(
                    content: Text('Save order to server successfully'),
                  ),
                );
                context.read<CartProvider>().clearProducts();
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routerName);
              }).catchError((e) {
                //Hide the loading
                Navigator.pop(context);
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Save order to server failed'),
                  ),
                );
              });
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final product = value.products[index];
                    return ListTile(
                      leading: Image.network(
                        product.imageUrl as String,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      title: Text('${product.title} - x${product.quantity!}'),
                      subtitle:
                          Text('${product.description} - \$${product.price}'),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              value.addItemToCart(product);
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              value.decreeQuantity(product);
                            },
                            icon: const Icon(Icons.text_decrease),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: value.products.length),
              const SizedBox(
                height: 20,
              ),
              Text('Total prices: \$${value.totalPrice}'),
            ],
          );
        },
      ),
    );
  }
}
