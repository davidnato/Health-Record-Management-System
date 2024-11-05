import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key, required List<Map<String, String>> patients});

  @override
  _PatientsListPageState createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  List<Map<String, String>> patients = []; // List to hold patient data

  @override
  void initState() {
    super.initState();
    _loadPatientsFromSharedPreferences();
  }

  // Method to load patient data from SharedPreferences
  Future<void> _loadPatientsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? patientsJsonList = prefs.getStringList('patients');

    // Check if there is data and deserialize JSON
    if (patientsJsonList != null) {
      setState(() {
        patients = patientsJsonList
            .map((patientJson) => Map<String, String>.from(jsonDecode(patientJson)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: patients.isNotEmpty
            ? ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(patient['fullName'] ?? 'No Name'),
                      subtitle: Text(
                        'DOB: ${patient['dob'] ?? 'N/A'}, Phone: ${patient['phone'] ?? 'N/A'}, Allergies: ${patient['allergies'] ?? 'N/A'}',
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text('No patients registered yet.')),
      ),
    );
  }
}
