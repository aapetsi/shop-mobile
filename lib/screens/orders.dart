import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/order.dart';
import 'package:mobile/widgets/order_list.dart';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final searchController = TextEditingController(text: '');
  late Future<List<Order>> orders = [] as Future<List<Order>>;
  late Future<List<Order>> o_ = [] as Future<List<Order>>;
  String total = '';

  handleOnChange(String val) {
    if (val.isNotEmpty) {
      setState(() {
        o_ = orders.then((value) => value
            .where(
                (o) => o.productName.toLowerCase().contains(val.toLowerCase()))
            .toList());
      });
    } else {
      setState(() {
        o_ = orders;
      });
    }
  }

  Future<List<Order>> fetchOrders() async {
    var url = Uri.http('127.0.0.1:8000', '/api/orders');
    final response = await http.get(url);
    List<Order> orders_ = [];

    if (response.statusCode == 200) {
      List<dynamic> o = jsonDecode(response.body);
      for (var element in o) {
        orders_.add(Order.fromJson(element));
      }

      return orders_;
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  fetchAndSetOrders() async {
    final res = fetchOrders();
    setState(() {
      orders = res;
      o_ = res;
    });
    res.then((List<Order> value) {
      setState(() {
        total =
            value.fold(0.0, (sum, o) => sum + o.amountPaid).toStringAsFixed(2);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            fetchAndSetOrders();
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
                    handleOnChange(val);
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
                    labelText: 'Search for an order',
                    hintText: 'Addidas Yeezy Boost',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const Text(
                      'Order History',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Text(
                      'Total: \$$total',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                OrderList(
                  orders: o_,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
