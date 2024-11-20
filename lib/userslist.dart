import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  Future<List<Map<String, String>>> _getUsers(String roleFilter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> users = [];

    // Get all keys and filter for user keys
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('user_')) {
        String username = key.split('_')[1]; // Extract username from the key
        String fullName = prefs.getString('fullName_$username') ?? '';
        String role = prefs.getString('role_$username') ?? '';
        if (role == roleFilter) {
          users.add({
            'username': username,
            'fullName': fullName,
            'role': role,
          });
        }
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors List'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _getUsers('Doctor'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          }

          List<Map<String, String>> doctors = snapshot.data!;
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return ListTile(
                title: Text(doctor['fullName'] ?? 'Unknown Doctor'),
                subtitle: Text('Username: ${doctor['username']}'),
              );
            },
          );
        },
      ),
    );
  }
}
