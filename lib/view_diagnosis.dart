import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewDiagnosisPage extends StatefulWidget {
  const ViewDiagnosisPage({super.key});

  @override
  _ViewDiagnosisPageState createState() => _ViewDiagnosisPageState();
}

class _ViewDiagnosisPageState extends State<ViewDiagnosisPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Fetch diagnoses from Firestore
  Stream<QuerySnapshot> _fetchDiagnoses() {
    return FirebaseFirestore.instance.collection('diagnoses').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnoses'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search by patient name",
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
          // Diagnoses list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fetchDiagnoses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("An error occurred while fetching diagnoses."),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No diagnoses found."),
                  );
                }

                final diagnoses = snapshot.data!.docs;

                // Filter diagnoses based on the search query
                final filteredDiagnoses = diagnoses.where((doc) {
                  final diagnosis = doc.data() as Map<String, dynamic>;
                  final fullName = (diagnosis['fullName'] ?? '').toString().toLowerCase();
                  return fullName.contains(_searchQuery);
                }).toList();

                if (filteredDiagnoses.isEmpty) {
                  return const Center(
                    child: Text("No matching diagnoses found."),
                  );
                }

                return ListView.builder(
                  itemCount: filteredDiagnoses.length,
                  itemBuilder: (context, index) {
                    final diagnosis = filteredDiagnoses[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        title: Text("Patient: ${diagnosis['fullName']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Symptoms: ${diagnosis['symptoms']}"),
                            Text("Diagnosis: ${diagnosis['diagnosis']}"),
                            Text(
                              "Date: ${DateTime.parse(diagnosis['date'].toDate().toString()).toLocal()}",
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
