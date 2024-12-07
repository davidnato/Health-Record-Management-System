import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePrescriptionPage extends StatefulWidget {
  const CreatePrescriptionPage({super.key});

  @override
  _CreatePrescriptionPageState createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  String _patientName = '';
  String _medication = '';
  String _dosage = '';
  String _instructions = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _firestore.collection('prescriptions').add({
          'patientName': _patientName,
          'medication': _medication,
          'dosage': _dosage,
          'instructions': _instructions,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription Added Successfully')),
        );

        _formKey.currentState?.reset();
      } catch (e) {
        print("Error adding prescription: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add prescription')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Prescription"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Name'),
                onChanged: (value) => _patientName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Patient Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Medication'),
                onChanged: (value) => _medication = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Medication is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dosage'),
                onChanged: (value) => _dosage = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dosage is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Instructions'),
                onChanged: (value) => _instructions = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Instructions are required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Add Prescription"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
