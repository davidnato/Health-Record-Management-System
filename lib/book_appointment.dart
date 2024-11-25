import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appointments.dart'; // Import AppointmentsPage

class BookAppointmentPage extends StatefulWidget {
  final Map<String, String> patient;

  const BookAppointmentPage({super.key, required this.patient});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  late String _doctorName;
  late String _appointmentDate;

  @override
  void initState() {
    super.initState();
    _doctorName = '';
    _appointmentDate = '';
  }

  Future<void> _saveAppointment(String patientId, String doctorName, String date) async {
    final prefs = await SharedPreferences.getInstance();
    final appointmentDetails = '$patientId|$date|$doctorName'; // Format as "ID|Date|Doctor"
    
    // Get the current list of appointments
    final List<String> appointments = prefs.getStringList('appointments') ?? [];

    // Add the new appointment to the list
    appointments.add(appointmentDetails);

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('appointments', appointments);
  }

  @override
  Widget build(BuildContext context) {
    final fullName = widget.patient['Full Name'] ?? 'Unknown Patient';
    final patientId = widget.patient['ID'] ?? 'Unknown ID';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking appointment for $fullName (ID: $patientId)',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Doctor's Name field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Doctor\'s Name',
                  hintText: 'Enter the doctor\'s name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _doctorName = value!;
                },
              ),
              const SizedBox(height: 20),

              // Appointment Date field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Appointment Date',
                  hintText: 'Select date',
                ),
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _appointmentDate = selectedDate.toLocal().toString().split(' ')[0]; // Formatting the date
                    });
                  }
                },
                readOnly: true,
                controller: TextEditingController(text: _appointmentDate),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Save the appointment details
                    _saveAppointment(patientId, _doctorName, _appointmentDate);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appointment Booked Successfully')),
                    );

                    // Navigate to AppointmentsPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentsPage()),
                    );
                  }
                },
                child: const Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
