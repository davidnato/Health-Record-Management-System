import 'package:flutter/material.dart';
import 'patient_registration.dart'; // Import patient registration page
import 'patientslist.dart'; // Import patients list page
import 'book_appointment.dart'; // Import the book appointment page
import 'billing.dart'; // Import the billing page
import 'login.dart'; // Import your login page

class ReceptionistPage extends StatefulWidget {
  const ReceptionistPage({super.key});

  @override
  _ReceptionistPageState createState() => _ReceptionistPageState();
}

class _ReceptionistPageState extends State<ReceptionistPage> {
  final List<Map<String, String>> _patients = []; // List to store registered patients
  int _selectedIndex = 0; // To track the selected page index

  void _addPatient(Map<String, String> patient) {
    setState(() {
      _patients.add(patient); // Add patient to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of pages corresponding to each button in the sidebar, passing required parameters
    final List<Widget> _pages = [
      PatientRegistrationPage(
        onPatientRegistered: _addPatient, // Pass the function to add patients
      ),
      PatientsListPage(
        patients: _patients, // Pass the patients list
      ),
      const BookAppointmentPage(), // Page for booking an appointment
      const BillingPage(), // Page for billing the patient
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptionist Page'),
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
                label: Text('Register New Patient'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text('View Patients List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today),
                label: Text('Book Appointment'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.attach_money),
                label: Text('Bill Patient'),
              ),
            ],
          ),
          
          // Main content area to display the selected page
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the login page
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
