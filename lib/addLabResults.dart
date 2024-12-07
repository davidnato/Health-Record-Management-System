import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddLabResultsPage extends StatefulWidget {
  const AddLabResultsPage({super.key});

  @override
  _AddLabResultsPageState createState() => _AddLabResultsPageState();
}

class _AddLabResultsPageState extends State<AddLabResultsPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store the entered values
  String _patientName = '';
  String _testName = '';
  String _testResult = '';
  DateTime _testDate = DateTime.now();

  // Controllers and Firestore instance
  final TextEditingController _patientSearchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search-related variables
  Map<String, String> _patients = {};
  bool _isLoading = false;

  // Function to search patients in Firestore
  Future<void> _searchPatient(String query) async {
    setState(() => _isLoading = true);
    try {
      final querySnapshot = await _firestore
          .collection('patients') // Update with the actual patients collection name
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _patients = {for (var doc in querySnapshot.docs) doc['fullName']: doc.id};
        _isLoading = false;
      });
    } catch (e) {
      print("Error searching patients: $e");
      setState(() => _isLoading = false);
    }
  }

  // Function to submit the form and save data to Firebase
  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Save data to Firestore
        await _firestore.collection('lab_results').add({
          'patientName': _patientName,
          'testName': _testName,
          'testResult': _testResult,
          'testDate': _testDate,
        });

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lab Result Added to Firebase')),
        );

        // Clear the form after submission
        _formKey.currentState?.reset();
        _patientSearchController.clear();
        setState(() {
          _patientName = '';
        });
      } catch (e) {
        print("Error saving lab result: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add lab result')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Lab Results"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Patient TextField
              TextField(
                controller: _patientSearchController,
                decoration: InputDecoration(
                  labelText: "Search Patient",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _searchPatient(_patientSearchController.text.trim()),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Display search results
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_patients.isNotEmpty)
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: _patients.keys.map((name) {
                      return ListTile(
                        title: Text(name),
                        subtitle: Text("ID: ${_patients[name]}"),
                        onTap: () {
                          setState(() {
                            _patientName = name;
                            _patientSearchController.text = name;
                            _patients.clear();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 20),

              // Test Name field
              _buildInputField(
                label: 'Test Name',
                onChanged: (value) => _testName = value,
              ),
              const SizedBox(height: 16),

              // Test Result field
              _buildInputField(
                label: 'Test Result',
                onChanged: (value) => _testResult = value,
              ),
              const SizedBox(height: 16),

              // Test Date Picker
              ListTile(
                title: Text("Test Date: ${_testDate.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _testDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null && selectedDate != _testDate) {
                    setState(() {
                      _testDate = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text("Submit Lab Result"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable function to build input fields with styling and validation
  Widget _buildInputField({
    required String label,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
