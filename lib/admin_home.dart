import 'package:flutter/material.dart';
import 'adduser.dart';
import 'userslist.dart';
import 'patientslist.dart'; // Import patientslist.dart
import 'login.dart'; // Import login.dart to use it for navigation

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final List<Map<String, String>> _patients = []; // List to store patient data
  int _selectedIndex = 0; // Track selected index for navigation

  // Method to add a patient
  void _addPatient(Map<String, String> patient) {
    setState(() {
      _patients.add(patient); // Add patient to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of pages corresponding to each button in the sidebar
    final List<Widget> pages = [
      const AddUserPage(), // Page for adding users
      const UsersListPage(), // Page for deleting users
      PatientsListPage(patients: _patients), // Page for viewing patient records
      const Center(child: Text("Update Records Page")), // Placeholder for Update Records page
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Display a dialog with notifications when the icon is pressed
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
          // Sidebar navigation
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
                icon: Icon(Icons.person_add),
                label: Text('Add Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.delete),
                label: Text('Delete Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_alt),
                label: Text('Check System Records'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.update),
                label: Text('Update Records'),
              ),
            ],
          ),
          
          // Main content area to display the selected page
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the login page on logout
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
