import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  Future<List<Map<String, String>>> _getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> users = [];

    // Get all keys and filter for user keys
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('user_')) {
        String username = key.split('_')[1]; // Extract username from the key
        String password = prefs.getString(key) ?? '';
        String fullName = prefs.getString('fullName_$username') ?? '';
        String role = prefs.getString('role_$username') ?? '';
        users.add({
          'username': username,
          'password': password,
          'fullName': fullName,
          'role': role,
        });
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          List<Map<String, String>> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['fullName'] ?? 'Unknown User'),
                subtitle: Text('Username: ${user['username']} - Role: ${user['role']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Add deletion functionality
                    _deleteUser(user['username']!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const UsersListPage()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteUser(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_$username');
    await prefs.remove('fullName_$username');
    await prefs.remove('role_$username');
  }
}
