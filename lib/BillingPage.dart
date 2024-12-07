import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Billing Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Patient Name: John Doe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Date of Billing: 2024-12-04",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Itemized Charges:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Example charges
            const BillingItem(description: "Consultation Fee", amount: 100),
            const BillingItem(description: "Lab Tests", amount: 50),
            const BillingItem(description: "Medication", amount: 30),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            // Total bill
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$180",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Payment logic or any action
              },
              child: const Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}

class BillingItem extends StatelessWidget {
  final String description;
  final double amount;

  const BillingItem({
    super.key,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(description),
        Text("\$${amount.toStringAsFixed(2)}"),
      ],
    );
  }
}
