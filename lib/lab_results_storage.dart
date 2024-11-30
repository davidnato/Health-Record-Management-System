import 'dart:async';

class LabResultsStorage {
  // This is a simple example. You can replace it with a database or more persistent storage.
  static final List<String> _labResults = [];

  // Save lab result (simulated storage)
  static Future<void> saveLabResult(String patientId, String result) async {
    try {
      // Simulating saving a lab result (e.g., you could add it to a database or shared preferences)
      _labResults.add('$patientId|$result');
      print('Lab result saved for patient $patientId: $result');
    } catch (e) {
      throw Exception('Failed to save lab result: $e');
    }
  }

  // Get all lab results (simulated retrieval)
  static Future<List<String>> getLabResults() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay or database query
    return _labResults; // Return the saved lab results
  }
}
