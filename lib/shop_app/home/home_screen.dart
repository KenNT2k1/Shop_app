import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/cart/cart_provider.dart';
import 'package:flutter_imic05/shop_app/cart/cart_screen.dart';
import 'package:flutter_imic05/shop_app/product/product_model.dart';
import 'package:flutter_imic05/shop_app/product/product_provider.dart';
import 'package:flutter_imic05/shop_app/widget/app_drawer.dart';
import 'package:provider/provider.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyShopScreen();
  }
}

class MyShopScreen extends StatefulWidget {
  static const routerName = "/shop_home_screen";
  const MyShopScreen({super.key});

  @override
  State<MyShopScreen> createState() => _MyShopScreenState();
}

class _MyShopScreenState extends State<MyShopScreen> {
  late Future<List<ProductModel>> _future;
  @override
  void initState() {
    var read = context.read<ProductProvider>();
    _future = read.getProductsFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Material App Bar'),
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routerName);
                  },
                  icon: const Icon(Icons.shopping_cart_outlined)),
              Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Text('${value.totalItems}'));
                },
              )
            ],
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, value, child) {
          return FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final products = snapshot.data;
                return GridView.builder(
                  itemCount: products?.length,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final product = products![index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailProduct(product: product),
                        ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GridTile(
                          footer: GridTileBar(
                            backgroundColor: Colors.black87,
                            title: Text(product.title as String),
                            subtitle: Text(product.description as String),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {},
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                              ),
                              onPressed: () {
                                context
                                    .read<CartProvider>()
                                    .addItemToCart(product);
                              },
                            ),
                          ),
                          child: Image.network(product.imageUrl as String,
                              fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}

class DetailProduct extends StatelessWidget {
  const DetailProduct({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                product.imageUrl as String,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 50,
                right: 0,
                child: Text(
                  product.title as String,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        Text(
          '\$${product.price}',
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          '${product.description}',
          style: const TextStyle(color: Colors.black),
        ),
      ]),
    );
  }
}
