import 'package:flutter/material.dart';
import 'package:hrms/DiagnosingPage.dart';
import 'package:hrms/PatientDetailsPage.dart';
import 'package:hrms/appointments_page.dart'; // Import AppointmentsPage
import 'package:hrms/patient_details_cluster.dart';
import 'package:hrms/prescriptions_page.dart';
import 'package:hrms/lab_results_page.dart';
import 'package:hrms/auth_screen.dart';
import 'package:hrms/view_diagnosis.dart';
import 'package:hrms/view_patient_records.dart'; // For logout redirection
import 'package:hrms/AppointmentPage.dart';
import 'package:hrms/addLabResults.dart'; // Adjust the path as per your folder structure
import 'package:hrms/patient_vitals_registration.dart';
import 'package:hrms/view_vitals.dart'; // Import Patient Vitals Registration Page

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});
  
  get selectedPatientId => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        backgroundColor: Colors.blueAccent, // Elegant color for healthcare
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title section with some spacing
              const Text(
                "Welcome, Dr. Smith",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your dashboard for managing appointments, prescriptions, and lab results.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Cards for each feature with rounded corners and shadows
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.schedule, color: Colors.blueAccent),
                  title: const Text("View Appointments"),
                  onTap: () {
                    String patientName = "John Doe";
                    String appointmentDate = "2024-12-10 14:00";
                    String doctorName = "Dr. Smith";
                    String reason = "Check-up";

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentsPage(
                          patientName: patientName,
                          appointmentDate: appointmentDate,
                          doctorName: doctorName,
                          reason: reason,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: const Text("View Patients"),
                  onTap: () {
                    String patientId = ''; // Pass an empty string or valid patientId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPatientRecordsPage(patientId: patientId),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
                  title: const Text("Diagnose Patient"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DiagnosingPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
                  title: const Text("View Diagnosis"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ViewDiagnosisPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.medical_services, color: Colors.blueAccent),
                  title: const Text("Manage Prescriptions"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrescriptionsPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.lan, color: Colors.blueAccent),
                  title: const Text("Review Lab Results"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LabResultsPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.add_circle, color: Colors.blueAccent),
                  title: const Text("Add Lab Results"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddLabResultsPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // New button to navigate to patient vitals registration
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.health_and_safety, color: Colors.blueAccent),
                  title: const Text("Register Patient Vitals"),
                  onTap: () {
                    String patientId = ''; // Pass an empty string or valid patientId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientVitalsRegistrationPage(patientId: patientId),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
