import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var publicKey = '';
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
    // Charge charge = Charge()
    //   ..amount = 10000
    //   ..reference = "_getReference()"
    //    // or ..accessCode = _getAccessCodeFrmInitialization()
    //   ..email = 'customer@email.com';
    // CheckoutResponse response = await plugin.checkout(
    //   context,
    //   method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
    //   charge: charge,
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
