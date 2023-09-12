import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imic05/shop_app/product/product_model.dart';
import 'package:flutter_imic05/shop_app/product/product_provider.dart';
import 'package:flutter_imic05/shop_app/widget/app_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  static const routerName = '/product_list_screen';
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
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
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: () async {
              final result =
                  await Navigator.of(context).pushNamed(EditProduct.routerName);
              if (result is ProductModel) {
                // ignore: use_build_context_synchronously
                context.read<ProductProvider>().addProduct(result);
              }
            },
            icon: const Icon(Icons.add),
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
                final products = snapshot.data!;
                return ListView.separated(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = products[index];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(product.imageUrl as String)),
                      title: Text(
                        product.title as String,
                      ),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed(EditProduct.routerName,
                                      arguments: product);
                              if (result is ProductModel) {
                                // ignore: use_build_context_synchronously
                                context
                                    .read<ProductProvider>()
                                    .updateProduct(result);
                              }
                            },
                          ),
                          IconButton(
                            iconSize: 24,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm delete'),
                                  content: Text(
                                      'Are you sure you want to delete - ${product.title}'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No')),
                                    ElevatedButton(
                                        onPressed: () {
                                          var read =
                                              context.read<ProductProvider>();
                                          read
                                              .deleteProductToServer(product)
                                              .then((value) =>
                                                  read.deleteProduct(product));
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Yes')),
                                  ],
                                ),
                              );
                              if (result == true) {}
                            },
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              });
        },
      ),
    );
  }
}

String generateRandomString(int len) {
  var r = Random();
  String randomString =
      String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  return randomString;
}

class EditProduct extends StatefulWidget {
  static const routerName = "edit_product";
  const EditProduct({super.key, this.product});
  final ProductModel? product;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String? _requiredValidation(String? value) {
    if (value?.isEmpty == true) {
      return 'This field is required';
    }
    return null;
  }

  ProductModel _product = const ProductModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.product != null) {
      _product = (widget.product!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product detail'),
          actions: [
            IconButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _formKey.currentState?.save();
                  // show  loading indicator
                  showDialog(
                    context: context,
                    builder: (context) => const Center(
                      child: SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator()),
                    ),
                  );
                  context
                      .read<ProductProvider>()
                      .updateProductToServer(_product)
                      .then((value) {
                    //hide loading indicator
                    Navigator.pop(context);
                    // return value
                    Navigator.pop(context, value);
                  });
                }
              },
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                  initialValue: _product.title?.toString(),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                  validator: _requiredValidation,
                  onSaved: (newValue) {
                    _product = _product.copyWith(title: newValue ?? '');
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _product.price?.toString(),
                  decoration: const InputDecoration(
                    hintText: 'Price',
                  ),
                  validator: (value) {
                    if (double.tryParse(value ?? '') == null) {
                      return 'Price must be a number';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _product = _product.copyWith(
                        price: double.tryParse(newValue ?? ''));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: _product.description,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  ),
                  validator: _requiredValidation,
                  onSaved: (newValue) {
                    _product = _product.copyWith(description: newValue ?? '');
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ImagePreview(
                  imageUrl: _product.imageUrl?.toString(),
                  validation: _requiredValidation,
                  onImageSaved: (value) {
                    _product = _product.copyWith(imageUrl: value ?? '');
                  },
                )
              ]),
            ),
          ),
        ));
  }
}

class ImagePreview extends StatefulWidget {
  const ImagePreview(
      {this.imageUrl,
      required this.validation,
      super.key,
      required this.onImageSaved});
  final String? imageUrl;
  final String? Function(String? value) validation;

  final void Function(String? value) onImageSaved;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  String? _localImageUrl;
  @override
  void initState() {
    _localImageUrl = widget.imageUrl;
    super.initState();
  }

  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            // pick file from local storage
            XFile? result =
                await imagePicker.pickImage(source: ImageSource.gallery);
            final resultPath = result?.path;
            if (resultPath != null) {
              // final file = File(resultPath);
              // Todo upload file

              try {
                final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: 'email2@grr.la', password: '123456');
                print('Login success');
                print(credential);
                // Create a storage reference from our app
                final storageRef = FirebaseStorage.instance.ref();
                File file = File(resultPath);
                // Create a reference to "mountains.jpg"
                final mountainsRef =
                    storageRef.child(file.path.split('/').last);

                try {
                  await mountainsRef.putData(file.readAsBytesSync());
                  print('Upload success');

                  _localImageUrl = await mountainsRef.getDownloadURL();
                  print(_localImageUrl);
                  widget.onImageSaved.call(_localImageUrl);
                } on FirebaseException catch (e) {
                  // ...
                  print(e);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                } else {
                  print(e);
                }
              }

              setState(() {
                _localImageUrl = resultPath;
              });
            } else {
              // User canceled the picker
            }
          },
          child: Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: _localImageUrl != null ? _getImage() : null,
              border: Border.all(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: TextFormField(
            initialValue: _localImageUrl,
            decoration: const InputDecoration(
              hintText: 'Image URL',
            ),
            validator: widget.validation,
            onSaved: (newValue) {
              // _product = _product.copyWith(imageUrl: newValue ?? '');
            },
          ),
        ),
      ],
    );
  }

  DecorationImage _getImage() {
    return _localImageUrl!.startsWith('https')
        ? DecorationImage(
            image: NetworkImage(_localImageUrl!),
            fit: BoxFit.cover,
          )
        : DecorationImage(
            image: FileImage(File(_localImageUrl!)),
            fit: BoxFit.cover,
          );
  }
}
