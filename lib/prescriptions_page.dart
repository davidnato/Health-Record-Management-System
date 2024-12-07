import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hrms/CreatePrescriptionPage.dart';
import 'package:hrms/ViewPrescriptionsPage.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  _PrescriptionsPageState createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  final TextEditingController _patientSearchController = TextEditingController();
  Map<String, String> _patients = {}; // To store patient names and IDs

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescriptions"),
        backgroundColor: Colors.teal, // A modern teal color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section with an intro text
            const Text(
              "Manage Prescriptions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // A brief description about the page
            const Text(
              "Here you can create new prescriptions, view existing ones, and manage them efficiently.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Search functionality
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
                            _patientSearchController.text = name;
                            _patients.clear();
                          });
                        },
                      );
                    }).toList(),
                  )
                : Container(),

            const SizedBox(height: 20),

            // Action buttons for creating/viewing prescriptions
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePrescriptionPage()),
                );
                print("Create New Prescription");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Matching color with the AppBar
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Create New Prescription",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewPrescriptionsPage()),
                );
                print("View Existing Prescriptions");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // A contrasting color for action
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "View Prescriptions",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
