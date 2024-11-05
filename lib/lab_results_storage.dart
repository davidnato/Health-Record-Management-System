import 'package:shared_preferences/shared_preferences.dart';

class LabResultsStorage {
  static const String _keyLabResults = 'lab_results';

  // Method to save lab results
  static Future<void> saveLabResult(String patientId, String result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> labResults = prefs.getStringList(_keyLabResults) ?? [];
    
    // Format: patientId|result
    labResults.add('$patientId|$result');
    
    // Save the updated list back to SharedPreferences
    await prefs.setStringList(_keyLabResults, labResults);
  }

  // Method to retrieve lab results
  static Future<List<String>> getLabResults() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyLabResults) ?? [];
  }
}
