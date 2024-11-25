import 'package:flutter/material.dart';

class UpdatePatientPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final Map<String, String> patientData; // Expecting the full patient data

  const UpdatePatientPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.patientData,  // Receiving the full patient data
  });

  @override
  _UpdatePatientPageState createState() => _UpdatePatientPageState();
}

class _UpdatePatientPageState extends State<UpdatePatientPage> {
  late TextEditingController _previousIllnessController;
  late TextEditingController _weightController;
  late TextEditingController _pressureController;
  late TextEditingController _temperatureController;

  @override
  void initState() {
    super.initState();
    _previousIllnessController = TextEditingController();
    _weightController = TextEditingController();
    _pressureController = TextEditingController();
    _temperatureController = TextEditingController();

    // You can pre-fill the fields with existing patient data if available
    _previousIllnessController.text = widget.patientData['Previous Illnesses'] ?? '';
    _weightController.text = widget.patientData['Weight'] ?? '';
    _pressureController.text = widget.patientData['Pressure'] ?? '';
    _temperatureController.text = widget.patientData['Temperature'] ?? '';
  }

  @override
  void dispose() {
    _previousIllnessController.dispose();
    _weightController.dispose();
    _pressureController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

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
            // Patient Name field (read-only)
            TextFormField(
              initialValue: widget.patientName,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            // Patient ID field (read-only)
            TextFormField(
              initialValue: widget.patientId,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient ID'),
            ),
            const SizedBox(height: 10),
            // Previous Illnesses field
            TextFormField(
              controller: _previousIllnessController,
              decoration: const InputDecoration(labelText: 'Previous Illnesses'),
            ),
            const SizedBox(height: 10),
            // Weight field
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 10),
            // Pressure field
            TextFormField(
              controller: _pressureController,
              decoration: const InputDecoration(labelText: 'Pressure (mmHg)'),
            ),
            const SizedBox(height: 10),
            // Temperature field
            TextFormField(
              controller: _temperatureController,
              decoration: const InputDecoration(labelText: 'Temperature (°C)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the updated details (you can implement the saving logic here)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Patient details updated successfully')),
                );
                Navigator.pop(context); // Go back to the previous page
              },
              child: const Text('Update Details'),
            ),
          ],
        ),
      ),
    );
  }
}
