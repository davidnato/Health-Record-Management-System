import 'package:flutter/material.dart';
import 'lab_results_storage.dart'; // Import the storage class

class AddLabResultsPage extends StatefulWidget {
  const AddLabResultsPage({super.key});

  @override
  _AddLabResultsPageState createState() => _AddLabResultsPageState();
}

class _AddLabResultsPageState extends State<AddLabResultsPage> {
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  void _saveLabResult() async {
    String patientId = _patientIdController.text;
    String result = _resultController.text;

    if (patientId.isNotEmpty && result.isNotEmpty) {
      await LabResultsStorage.saveLabResult(patientId, result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lab result saved for patient $patientId')),
      );

      // Clear input fields
      _patientIdController.clear();
      _resultController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lab Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _patientIdController,
              decoration: const InputDecoration(labelText: 'Patient ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _resultController,
              decoration: const InputDecoration(labelText: 'Lab Result'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLabResult,
              child: const Text('Save Lab Result'),
            ),
          ],
        ),
      ),
    );
  }
}
