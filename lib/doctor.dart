import 'package:flutter/material.dart';
import 'login.dart';
import 'lab_results.dart';
import 'appointments.dart';
import 'patientslist.dart';
import 'update_patient.dart';
import 'add_lab_results.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final List<Map<String, String>> _patients = [];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const LabResultsPage(),
      const AppointmentsPage(),
      PatientsListPage(patients: _patients),
      const UpdatePatientPage(),
      const AddLabResultsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: const Text('You have new notifications.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.science),
                label: Text('Check Lab Results'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today),
                label: Text('Check Appointments'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Check Patient Details'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.edit),
                label: Text('Update Patient Details'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add),
                label: Text('Add Lab Results'),
              ),
            ],
          ),
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
