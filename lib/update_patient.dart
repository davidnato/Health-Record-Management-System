import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

    // Pre-fill the fields with existing patient data
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

  // Save updated patient data to SharedPreferences
  Future<void> _updatePatientData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> patientsJsonList = prefs.getStringList('patients') ?? [];

    // Find the patient and update the details
    for (int i = 0; i < patientsJsonList.length; i++) {
      Map<String, dynamic> patient = jsonDecode(patientsJsonList[i]);
      if (patient['ID'] == widget.patientId) {
        patient['Previous Illnesses'] = _previousIllnessController.text;
        patient['Weight'] = _weightController.text;
        patient['Pressure'] = _pressureController.text;
        patient['Temperature'] = _temperatureController.text;

        // Update the patient in the list
        patientsJsonList[i] = jsonEncode(patient);
        break;
      }
    }

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('patients', patientsJsonList);

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient details updated successfully')),
    );

    Navigator.pop(context); // Go back to the previous page
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
            TextFormField(
              initialValue: widget.patientName,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.patientId,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient ID'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _previousIllnessController,
              decoration: const InputDecoration(labelText: 'Previous Illnesses'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _pressureController,
              decoration: const InputDecoration(labelText: 'Pressure (mmHg)'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _temperatureController,
              decoration: const InputDecoration(labelText: 'Temperature (°C)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePatientData,
              child: const Text('Update Details'),
            ),
          ],
        ),
      ),
    );
  }
}
