import 'package:flutter/material.dart';

class UpdatePatientPage extends StatelessWidget {
  const UpdatePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Patient Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Patient ID or Name"),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Update Phone Number"),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Update Medical History"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update patient logic here
              },
              child: const Text("Update Patient"),
            ),
          ],
        ),
      ),
    );
  }
}
