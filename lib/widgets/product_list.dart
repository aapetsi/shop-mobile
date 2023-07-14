import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:mobile/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  final Future<List<Product>> products;
  const ProductList({super.key, required this.products});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var publicKey = 'pk_test_aa904077050e2443e1915082ba98e8b3666ca46d';
  final plugin = PaystackPlugin();
  late Future<List<Product>> products = [] as Future<List<Product>>;
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  createOrder(payload) {
    var url = Uri.http('127.0.0.1:8000', '/api/register');
    http.post(url, body: {'payload': payload});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: double.infinity,
        maxHeight: 650,
      ),
      child: FutureBuilder<List<Product>>(
        future: widget.products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                ...snapshot.data!
                    .map(
                      (e) => Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Image.network(
                                    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80"),
                                title: Text(e.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.category.name),
                                    Text('\$ ${e.amount.toStringAsFixed(2)}')
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  child: const Text('Buy'),
                                  onPressed: () async {
                                    Charge charge = Charge()
                                      ..amount = (e.amount * 100).round()
                                      ..reference = "shop_app_282727727"
                                      ..email = 'apetsi@gmail.com';
                                    CheckoutResponse response =
                                        await plugin.checkout(
                                      context,
                                      method: CheckoutMethod.card,
                                      charge: charge,
                                    );
                                    // create order here
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList()
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('error');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
