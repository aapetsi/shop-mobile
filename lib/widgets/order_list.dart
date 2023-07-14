import 'package:flutter/material.dart';
import 'package:mobile/models/order.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  final Future<List<Order>> orders;
  const OrderList({super.key, required this.orders});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  String formatDate(String inputDate) {
    final parsedDate = DateTime.parse(inputDate);
    final formatter = DateFormat('dd MMMM yyyy');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          minHeight: 100,
          minWidth: double.infinity,
          maxHeight: 650,
        ),
        child: FutureBuilder<List<Order>>(
          future: widget.orders,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  ...snapshot.data!.map(
                    (e) => Container(
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.payment),
                              title: Text(e.productName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.transactionReference),
                                  Text(formatDate(e.createdAt))
                                ],
                              ),
                              trailing: Text('\$${e.amountPaid.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green[500]),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Text('Error occured fetching orders');
            }

            return const CircularProgressIndicator();
          },
        ));
  }
}
