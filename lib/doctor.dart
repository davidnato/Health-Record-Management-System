import 'package:flutter/material.dart';
import 'login.dart';
import 'lab_results.dart';
import 'appointments.dart';
import 'patientslist.dart';
import 'add_lab_results.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final List<Map<String, String>> _patients = [
    {'ID': '001', 'Full Name': 'John Doe', 'Date of Birth': '01/01/1990', 'Phone Number': '1234567890'},
    {'ID': '002', 'Full Name': 'Jane Smith', 'Date of Birth': '02/02/1985', 'Phone Number': '9876543210'},
    // Add more patients as necessary
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const LabResultsPage(),
      const AppointmentsPage(),
      PatientsListPage(
  patients: _patients,  // Pass the list of patients
  onPatientSelected: (patient) {
    // Handle the selected patient here, e.g., navigate to another page or update data
    print('Patient selected: ${patient['Full Name']}');
  },
),

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
