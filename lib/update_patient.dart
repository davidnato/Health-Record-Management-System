import 'package:flutter/material.dart';

class UpdatePatientPage extends StatelessWidget {
  final String patientId;
  final String patientName;

  const UpdatePatientPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: patientName,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: patientId,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient ID'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Previous Illnesses'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Pressure (mmHg)'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Temperature (°C)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save updated details logic here
              },
              child: const Text('Update Details'),
            ),
          ],
        ),
      ),
    );
  }
}
