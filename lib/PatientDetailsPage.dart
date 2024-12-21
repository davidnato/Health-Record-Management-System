import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'view_patient_records.dart';

class ViewPatientRecordsPage extends StatefulWidget {
  const ViewPatientRecordsPage({super.key, required patientId});

  @override
  _ViewPatientRecordsPageState createState() => _ViewPatientRecordsPageState();
}

class _ViewPatientRecordsPageState extends State<ViewPatientRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Records"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),
          // Patient Records
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('patients').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No patient records found."));
                } else {
                  final patientDocs = snapshot.data!.docs;
                  
                  // Filter patients by search query
                  final filteredPatients = patientDocs.where((doc) {
                    final patientData = doc.data() as Map<String, dynamic>;
                    final fullName = (patientData['fullName'] ?? '').toString().toLowerCase();
                    return fullName.contains(_searchQuery);
                  }).toList();

                  if (filteredPatients.isEmpty) {
                    return const Center(child: Text("No matching patient records found."));
                  }

                  return ListView.builder(
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patientData = filteredPatients[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            patientData['fullName'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone: ${patientData['phone'] ?? 'N/A'}'),
                              Text('Email: ${patientData['email'] ?? 'N/A'}'),
                              Text('DOB: ${patientData['dob'] ?? 'N/A'}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailsPage(
                                  patientData: patientData,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
