import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Billing Information")),
      body: const Center(
        child: Text("Billing Details"),
      ),
    );
  }
}
