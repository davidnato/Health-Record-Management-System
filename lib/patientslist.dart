import 'package:flutter/material.dart';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key, required this.patients});

  final List<Map<String, String>> patients;

  @override
  _PatientsListPageState createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.patients.isNotEmpty
            ? ListView.builder(
                itemCount: widget.patients.length,
                itemBuilder: (context, index) {
                  final patient = widget.patients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(patient['Full Name'] ?? 'No Name'),
                      subtitle: Text(
                        'ID: ${patient['ID'] ?? 'N/A'}\n'
                        'DOB: ${patient['Date of Birth'] ?? 'N/A'}, Phone: ${patient['Phone Number'] ?? 'N/A'}',
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
