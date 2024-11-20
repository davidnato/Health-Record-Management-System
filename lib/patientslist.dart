import 'package:flutter/material.dart';


class PatientsListPage extends StatelessWidget {
  final List<Map<String, String>> patients;
  final Function(Map<String, String>) onPatientSelected;

  // Constructor now requires `onPatientSelected`
  const PatientsListPage({
    super.key,
    required this.patients,
    required this.onPatientSelected, // This is the missing required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: patients.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Patient ID')),
                    DataColumn(label: Text('Full Name')),
                    DataColumn(label: Text('DOB')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: patients.map((patient) {
                    return DataRow(
                      cells: [
                        DataCell(Text(patient['ID'] ?? 'N/A')),
                        DataCell(Text(patient['Full Name'] ?? 'No Name')),
                        DataCell(Text(patient['Date of Birth'] ?? 'N/A')),
                        DataCell(Text(patient['Phone Number'] ?? 'N/A')),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Use the `onPatientSelected` callback when a patient is selected
                                  onPatientSelected(patient);
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              )
            : const Center(child: Text('No patients registered yet.')),
      ),
    );
  }
}
