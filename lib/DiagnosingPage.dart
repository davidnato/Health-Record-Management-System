import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiagnosingPage extends StatefulWidget {
  const DiagnosingPage({super.key});

  @override
  State<DiagnosingPage> createState() => _DiagnosingPageState();
}

class _DiagnosingPageState extends State<DiagnosingPage> {
  final TextEditingController _patientSearchController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  Map<String, dynamic> _selectedPatient = {};
  Map<String, String> _patients = {};
  bool _isLoading = false;

  // Search patients in Firestore
  Future<void> _searchPatient(String query) async {
    setState(() => _isLoading = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients') // Change to the correct collection name
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _patients = {
          for (var doc in querySnapshot.docs) doc['fullName']: doc.id
        };
        _isLoading = false;
      });
    } catch (e) {
      print("Error searching patients: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveDiagnosis() async {
    if (_selectedPatient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No patient selected")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('diagnoses').add({
        'userId': _selectedPatient['id'],
        'fullName': _selectedPatient['fullName'],
        'symptoms': _symptomsController.text.trim(),
        'diagnosis': _diagnosisController.text.trim(),
        'medications': _medicationsController.text.trim(),
        'date': DateTime.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diagnosis saved successfully!")),
      );

      // Clear input fields
      _symptomsController.clear();
      _diagnosisController.clear();
      _medicationsController.clear();
      setState(() {
        _selectedPatient = {};
        _patientSearchController.clear();
      });
    } catch (e) {
      print("Error saving diagnosis: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save diagnosis")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosing Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Patient TextField
            TextField(
              controller: _patientSearchController,
              decoration: InputDecoration(
                labelText: "Search Patient by Name",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchPatient(_patientSearchController.text.trim()),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Display search results
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_patients.isNotEmpty)
              Expanded(
                child: ListView(
                  children: _patients.keys.map((name) {
                    return ListTile(
                      title: Text(name),
                      subtitle: Text("ID: ${_patients[name]}"),
                      onTap: () {
                        setState(() {
                          _selectedPatient = {
                            'id': _patients[name]!,
                            'fullName': name,
                          };
                          _patientSearchController.text = name;
                          _patients.clear();
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),

            // Selected Patient Details
            if (_selectedPatient.isNotEmpty)
              Card(
                elevation: 3,
                child: ListTile(
                  title: Text(_selectedPatient['fullName']!),
                  subtitle: Text("ID: ${_selectedPatient['id']}"),
                ),
              ),
            const SizedBox(height: 20),

            // Diagnosis Fields
            TextField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: "Symptoms",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: "Diagnosis",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _medicationsController,
              decoration: const InputDecoration(
                labelText: "Prescribed Medications",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Save Diagnosis Button
            ElevatedButton(
              onPressed: _saveDiagnosis,
              child: const Text("Save Diagnosis"),
            ),
          ],
        ),
      ),
    );
  }
}
