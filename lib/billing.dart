import 'package:flutter/material.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _billPatient() {
    // Billing logic can be implemented here
    String patientName = _patientNameController.text;
    String amount = _amountController.text;

    // Display billing confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Billed $patientName an amount of \$$amount')),
    );

    // Clear the fields after billing
    _patientNameController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _patientNameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _billPatient,
              child: const Text('Bill Patient'),
            ),
          ],
        ),
      ),
    );
  }
}
