import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class RegisterPatientPage extends StatefulWidget {
  const RegisterPatientPage({super.key});

  @override
  _RegisterPatientPageState createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final _formKey = GlobalKey<FormState>(); // Form validation key
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _insuranceCompanyController = TextEditingController();
  final _insurancePolicyController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  // Date of Birth Controller and selected date
  final TextEditingController _dobController = TextEditingController();
  DateTime? _dob;

  // Gender dropdown value
  String _gender = 'Male';

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to register the patient
  void _registerPatient() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Collect patient data
        final patientData = {
          'fullName': _fullNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'dob': Timestamp.fromDate(_dob!), // Store the date as Firestore Timestamp
          'email': _emailController.text.trim(),
          'gender': _gender,
          'address': _addressController.text.trim(),
          'emergencyContactName': _emergencyNameController.text.trim(),
          'emergencyContactPhone': _emergencyPhoneController.text.trim(),
          'insuranceCompany': _insuranceCompanyController.text.trim(),
          'insurancePolicy': _insurancePolicyController.text.trim(),
          'medicalHistory': _medicalHistoryController.text.trim(),
        };

        // Add to Firestore
        await _firestore.collection('patients').add(patientData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Patient Registered Successfully!"),
          backgroundColor: Colors.green,
        ));

        // Clear form fields
        _clearForm();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // Function to clear form fields
  void _clearForm() {
    _fullNameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _emergencyNameController.clear();
    _emergencyPhoneController.clear();
    _insuranceCompanyController.clear();
    _insurancePolicyController.clear();
    _medicalHistoryController.clear();
    _dobController.clear();
  }

  // DatePicker to select Date of Birth
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dob ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _dob) {
      setState(() {
        _dob = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_dob!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Patient")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign formKey to enable validation
            child: Column(
              children: [
                // Full Name Input Field
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient\'s full name';
                    }
                    return null;
                  },
                ),
                // Phone Input Field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: "Phone"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                // Date of Birth (using DatePicker widget)
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true, // Make the text field non-editable
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the date of birth';
                    }
                    return null;
                  },
                ),
                // Email Input Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email address';
                    }
                    return null;
                  },
                ),
                // Gender Dropdown
                DropdownButtonFormField<String>(
                  value: _gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: "Gender"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
                // Address Input Field
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                // Emergency Contact Name Input Field
                TextFormField(
                  controller: _emergencyNameController,
                  decoration: const InputDecoration(labelText: "Emergency Contact Name"),
                ),
                // Emergency Contact Phone Input Field
                TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(labelText: "Emergency Contact Phone"),
                  keyboardType: TextInputType.phone,
                ),
                // Insurance Company Input Field
                TextFormField(
                  controller: _insuranceCompanyController,
                  decoration: const InputDecoration(labelText: "Insurance Company"),
                ),
                // Insurance Policy Number Input Field
                TextFormField(
                  controller: _insurancePolicyController,
                  decoration: const InputDecoration(labelText: "Insurance Policy Number"),
                ),
                // Medical History Input Field
                TextFormField(
                  controller: _medicalHistoryController,
                  decoration: const InputDecoration(labelText: "Medical History"),
                ),
                const SizedBox(height: 20),
                // Register Button
                ElevatedButton(
                  onPressed: _registerPatient,
                  child: const Text("Register Patient"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
