import 'package:flutter/material.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/screens/orders.dart';
import 'package:mobile/widgets/product_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final searchController = TextEditingController(text: '');
  late Future<List<Product>> products = [] as Future<List<Product>>;
  late Future<List<Product>> p_ = [] as Future<List<Product>>;

  handlOnChange(String val) {
    if (val.isNotEmpty) {
      setState(() {
        p_ = products.then((value) => value
            .where((p) => p.name.toLowerCase().contains(val.toLowerCase()))
            .toList());
      });
    } else {
      setState(() {
        p_ = products;
      });
    }
  }

  Future<List<Product>> fetchProducts() async {
    var url = Uri.http('127.0.0.1:8000', '/api/products');
    final response = await http.get(url);
    List<Product> products_ = [];

    if (response.statusCode == 200) {
      List<dynamic> p = jsonDecode(response.body);
      for (var element in p) {
        products_.add(Product.fromJson(element));
      }

      return products_;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  fetchAndSetProducts() {
    final res = fetchProducts();
    setState(() {
      products = res;
      p_ = res;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            fetchAndSetProducts();
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
          child: Container(
            height: 900,
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (val) async {
                    handlOnChange(val);
                  },
                  controller: searchController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.purple),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search for a product',
                    hintText: 'Addidas Yeezy Boost',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const Text(
                      'Latest Products',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Orders()));
                        },
                        child: const Text('My Orders'))
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                ProductList(
                  products: p_,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
