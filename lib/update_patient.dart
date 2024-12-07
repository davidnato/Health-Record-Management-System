import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePatientPage extends StatefulWidget {
  const UpdatePatientPage({super.key});

  @override
  _UpdatePatientPageState createState() => _UpdatePatientPageState();
}

class _UpdatePatientPageState extends State<UpdatePatientPage> {
  final TextEditingController _patientSearchController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();

  // Map to store search results (patient name -> patient ID)
  Map<String, String> _patients = {};

  // Function to search patients in Firestore
  Future<void> _searchPatient(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _patients = {
          for (var doc in querySnapshot.docs)
            doc['fullName']: doc.id
        };
      });
    } catch (e) {
      print("Error searching patients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Patient Information"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Text
              Text(
                "Update Patient's Information",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Search for Patient
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  filled: true,
                  fillColor: Colors.grey[100],
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
                              _patientSearchController.text = name;
                              _patients.clear(); // Clear the search results
                            });
                          },
                        );
                      }).toList(),
                    )
                  : Container(),
              const SizedBox(height: 16),

              // Phone Number Field
              _buildInputField(
                controller: _phoneNumberController,
                label: "Update Phone Number",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Medical History Field
              _buildInputField(
                controller: _medicalHistoryController,
                label: "Update Medical History",
                keyboardType: TextInputType.text,
                maxLines: 4,
              ),
              const SizedBox(height: 30),

              // Update Button
              ElevatedButton(
                onPressed: () {
                  // Implement patient update logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Update Patient"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to build input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
