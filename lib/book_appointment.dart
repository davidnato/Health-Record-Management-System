import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _appointmentDateController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();

  Future<void> _bookAppointment() async {
    String patientName = _patientNameController.text;
    String appointmentDate = _appointmentDateController.text;
    String doctorName = _doctorNameController.text;

    if (patientName.isNotEmpty && appointmentDate.isNotEmpty && doctorName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final List<String> appointments = prefs.getStringList('appointments') ?? [];
      
      // Create a new appointment entry
      String appointment = '$patientName|$appointmentDate|$doctorName';
      appointments.add(appointment);
      
      // Store the updated list back to SharedPreferences
      await prefs.setStringList('appointments', appointments);

      // Display confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked for $patientName with Dr. $doctorName on $appointmentDate')),
      );

      // Clear the fields after booking
      _patientNameController.clear();
      _appointmentDateController.clear();
      _doctorNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _patientNameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _appointmentDateController,
              decoration: const InputDecoration(labelText: 'Appointment Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _doctorNameController,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _bookAppointment,
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
