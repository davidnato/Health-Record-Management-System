import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController _patientSearchController = TextEditingController();
  final Map<String, String> _patients = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Billing Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search for patient
              TextField(
                controller: _patientSearchController,
                decoration: InputDecoration(
                  labelText: "Search Patient",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchPatient(_patientSearchController.text);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Display search results
              _patients.isNotEmpty
                  ? ListView(
                      shrinkWrap: true,
                      children: _patients.keys.map((name) {
                        return ListTile(
                          title: Text(name),
                          subtitle: Text("ID: ${_patients[name]}"),
                          onTap: () {
                            setState(() {
                              _patientSearchController.text = name;
                              _patients.clear();
                            });
                          },
                        );
                      }).toList(),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 20),

              const Text(
                "Itemized Charges:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const BillingItem(description: "Consultation Fee", amount: 100),
              const BillingItem(description: "Lab Tests", amount: 50),
              const BillingItem(description: "Medication", amount: 30),
              const Divider(),
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
                  // Payment logic
                },
                child: const Text("Proceed to Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search patients in Firestore
  Future<void> _searchPatient(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _patients.clear();
        for (var doc in querySnapshot.docs) {
          _patients[doc['fullName']] = doc.id;
        }
      });
    } catch (e) {
      print("Error searching patients: $e");
    }
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
