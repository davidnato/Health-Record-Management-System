import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientVitalsRegistrationPage extends StatefulWidget {
  const PatientVitalsRegistrationPage({super.key, required this.patientId});

  final String patientId;

  @override
  _PatientVitalsRegistrationPageState createState() =>
      _PatientVitalsRegistrationPageState();
}

class _PatientVitalsRegistrationPageState
    extends State<PatientVitalsRegistrationPage> {
  final TextEditingController _patientSearchController = TextEditingController();
  Map<String, String> _patients = {};
  String _selectedPatientId = '';

  final TextEditingController _bodyTemperatureController =
      TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _respiratoryRateController =
      TextEditingController();
  final TextEditingController _oxygenSaturationController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _pastMedicalHistoryController =
      TextEditingController();

  // Search patients in Firestore
  Future<void> _searchPatient(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _patients = {
          for (var doc in querySnapshot.docs) doc['fullName']: doc.id
        };
      });
    } catch (e) {
      print("Error searching patients: $e");
    }
  }

  // Save vital signs to Firestore
  Future<void> _saveVitals() async {
    if (_selectedPatientId.isEmpty) {
      print("No patient selected!");
      return;
    }

    try {
      // Get the current patient's document
      DocumentReference patientDoc =
          FirebaseFirestore.instance.collection('patients').doc(_selectedPatientId);

      // Fetch existing patient data
      DocumentSnapshot patientSnapshot = await patientDoc.get();

      // Create the new vital entry with a timestamp
      Map<String, String> newVitals = {
        'bodyTemperature': _bodyTemperatureController.text,
        'heartRate': _heartRateController.text,
        'bloodPressure': _bloodPressureController.text,
        'respiratoryRate': _respiratoryRateController.text,
        'oxygenSaturation': _oxygenSaturationController.text,
        'weight': _weightController.text,
        'height': _heightController.text,
        'allergies': _allergiesController.text,
        'pastMedicalHistory': _pastMedicalHistoryController.text,
        'timestamp': DateTime.now().toIso8601String(), // Add a timestamp for uniqueness
      };

      // Save the new vital data to the historical vitals array and also update the latestVitals field
      await patientDoc.update({
        'vitals': FieldValue.arrayUnion([newVitals]), // Add to the historical data array
        'latestVitals': newVitals, // Store the latest vitals separately
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vitals saved successfully!')));
    } catch (e) {
      print("Error saving vitals: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Vitals Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Patient Search
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
                            _selectedPatientId = _patients[name]!;
                            _patientSearchController.text = name;
                            _patients.clear();
                          });
                        },
                      );
                    }).toList(),
                  )
                : Container(),

            const SizedBox(height: 20),

            // Vitals input fields
            TextField(
              controller: _bodyTemperatureController,
              decoration: const InputDecoration(labelText: "Body Temperature (°C)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heartRateController,
              decoration: const InputDecoration(labelText: "Heart Rate (bpm)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _bloodPressureController,
              decoration: const InputDecoration(labelText: "Blood Pressure (e.g., 120/80 mmHg)"),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _respiratoryRateController,
              decoration: const InputDecoration(labelText: "Respiratory Rate (breaths/min)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _oxygenSaturationController,
              decoration: const InputDecoration(labelText: "Oxygen Saturation (%)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: "Height (cm)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: "Allergies"),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _pastMedicalHistoryController,
              decoration: const InputDecoration(labelText: "Past Medical History"),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: _saveVitals,
              child: const Text('Save Vitals'),
            ),
          ],
        ),
      ),
    );
  }
}
