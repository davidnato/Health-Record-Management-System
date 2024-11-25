import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PatientRegistrationPage extends StatefulWidget {
  const PatientRegistrationPage({super.key});

  @override
  _PatientRegistrationPageState createState() =>
      _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  // Save the patient list to SharedPreferences
  Future<void> _savePatientToSharedPreferences(Map<String, String> newPatient) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the current list of patients from SharedPreferences
    List<String> patientsJsonList = prefs.getStringList('patients') ?? [];
    patientsJsonList.add(jsonEncode(newPatient)); // Add the new patient as a JSON string

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('patients', patientsJsonList);
  }

  void _registerPatient() async {
    // Collecting data from the input fields
    String fullName = _fullNameController.text;
    String dob = _dobController.text;
    String phone = _phoneController.text;
    String allergies = _allergiesController.text;

    // Create a new patient record
    Map<String, String> newPatient = {
      'Full Name': fullName,
      'Date of Birth': dob,
      'Phone Number': phone,
      'Allergies': allergies,
    };

    // Save the new patient to SharedPreferences
    await _savePatientToSharedPreferences(newPatient);

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Patient registered: $fullName')),
    );

    // Clear the fields after registration
    _fullNameController.clear();
    _dobController.clear();
    _phoneController.clear();
    _allergiesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies (Optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerPatient,
              child: const Text('Register Patient'),
            ),
          ],
        ),
      ),
    );
  }
}
