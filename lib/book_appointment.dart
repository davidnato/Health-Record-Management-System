import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointmentPage extends StatefulWidget {
  final String? patientId;
  final String? patientName;

  const BookAppointmentPage({super.key, this.patientId, this.patientName});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final TextEditingController _appointmentDateController = TextEditingController();
  String? _selectedDoctor; // Stores the selected doctor username
  List<Map<String, String>> _doctors = []; // List of doctors

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<Map<String, String>> doctors = [];

    for (String key in keys) {
      if (key.startsWith('user_')) {
        String username = key.split('_')[1];
        String fullName = prefs.getString('fullName_$username') ?? '';
        String role = prefs.getString('role_$username') ?? '';
        if (role == 'Doctor') {
          doctors.add({'username': username, 'fullName': fullName});
        }
      }
    }

    setState(() {
      _doctors = doctors;
    });
  }

  Future<void> _bookAppointment() async {
    if (widget.patientId != null &&
        _appointmentDateController.text.isNotEmpty &&
        _selectedDoctor != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> appointments = prefs.getStringList('appointments') ?? [];

      String appointment =
          '${widget.patientId}|${_appointmentDateController.text}|$_selectedDoctor';
      appointments.add(appointment);
      await prefs.setStringList('appointments', appointments);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully.')),
      );

      // Clear fields
      _appointmentDateController.clear();
      setState(() {
        _selectedDoctor = null;
      });
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
            TextFormField(
              initialValue: widget.patientName,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.patientId,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Patient ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _appointmentDateController,
              decoration:
                  const InputDecoration(labelText: 'Appointment Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDoctor,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Assign Doctor'),
              items: _doctors.map((doctor) {
                return DropdownMenuItem(
                  value: doctor['username'],
                  child: Text(doctor['fullName']!),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedDoctor = value),
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
