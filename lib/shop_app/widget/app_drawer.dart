import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/cart/order_screen.dart';
import 'package:flutter_imic05/shop_app/home/home_screen.dart';
import 'package:flutter_imic05/shop_app/product/edit_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                MyShopScreen.routerName,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                ProductListScreen.routerName,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Order'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                OrderScreen.routerName,
              );
            },
          ),
        ],
      ),
    );
  }
}
