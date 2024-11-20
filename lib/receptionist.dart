import 'package:flutter/material.dart';
import 'patientslist.dart'; // Import patients list page
import 'book_appointment.dart'; // Import the book appointment page
import 'billing.dart'; // Import the billing page
import 'login.dart'; // Import your login page
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
      // Generate a unique ID based on the current time in milliseconds
      final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      patient['ID'] = uniqueId;  // Add unique ID to the patient data
      _patients.add(patient); // Add patient to the list
    });
    _savePatientsToSharedPreferences(); // Save the updated patients list to SharedPreferences
  }

  Future<void> _savePatientsToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJsonList = _patients.map((patient) => jsonEncode(patient)).toList();
    await prefs.setStringList('patients', patientsJsonList);
  }

  @override
  Widget build(BuildContext context) {
    // List of pages corresponding to each button in the sidebar, passing required parameters
    final List<Widget> pages = [
      PatientRegistrationPage(
        onPatientRegistered: _addPatient, // Pass the function to add patients
      ),
      PatientsListPage(
  patients: _patients,  // Pass the list of patients
  onPatientSelected: (patient) {
    // Handle the selected patient here, e.g., navigate to another page or update data
    print('Patient selected: ${patient['Full Name']}');
  },
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
            child: pages[_selectedIndex],
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

class PatientRegistrationPage extends StatefulWidget {
  final Function(Map<String, String>) onPatientRegistered;

  const PatientRegistrationPage({required this.onPatientRegistered, super.key});

  @override
  _PatientRegistrationPageState createState() => _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _patientData = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Please enter full name' : null,
                onSaved: (value) => _patientData['Full Name'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
                onSaved: (value) => _patientData['Date of Birth'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) => value!.isEmpty ? 'Please enter gender' : null,
                onSaved: (value) => _patientData['Gender'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
                onSaved: (value) => _patientData['Phone Number'] = value!,
              ),
              const SizedBox(height: 16),
              const Text('Identification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'National ID or Passport'),
                validator: (value) => value!.isEmpty ? 'Please enter ID or Passport number' : null,
                onSaved: (value) => _patientData['National ID/Passport'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Insurance Provider'),
                validator: (value) => value!.isEmpty ? 'Please enter insurance provider' : null,
                onSaved: (value) => _patientData['Insurance Provider'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Policy Number'),
                validator: (value) => value!.isEmpty ? 'Please enter policy number' : null,
                onSaved: (value) => _patientData['Policy Number'] = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onPatientRegistered(_patientData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Patient Registered Successfully')),
                    );
                  }
                },
                child: const Text('Register Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
