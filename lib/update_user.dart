import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key});

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // Variable to store the selected user data
  Map<String, dynamic>? _selectedUser;

  // Search for the user in Firestore
  Future<void> _searchUser(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final user = querySnapshot.docs.first;
        setState(() {
          _selectedUser = {
            'id': user.id,
            'fullName': user['fullName'],
            'email': user['email'],
            'phone': user['phone'],
          };
          _fullNameController.text = _selectedUser!['fullName'];
          _emailController.text = _selectedUser!['email'];
          _phoneController.text = _selectedUser!['phone'];
        });
      } else {
        setState(() {
          _selectedUser = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found")),
        );
      }
    } catch (e) {
      print("Error searching user: $e");
    }
  }

  // Update the user data in Firestore
  Future<void> _updateUser() async {
    if (_selectedUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_selectedUser!['id'])
            .update({
          'fullName': _fullNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User updated successfully")),
        );
      } catch (e) {
        print("Error updating user: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (query) {
                _searchUser(query);
              },
              decoration: InputDecoration(
                labelText: "Search User by Full Name",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                suffixIcon: Icon(Icons.search, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),

            // Display user information only if a user is selected
            if (_selectedUser != null) ...[
              // Full Name Input Field
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(height: 10),

              // Email Input Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),

              // Phone Number Input Field
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              const SizedBox(height: 20),

              // Update Button
              ElevatedButton(
                onPressed: _updateUser,
                child: const Text("Update User"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ] else ...[
              const Text("No user found, please search for a user."),
            ],
          ],
        ),
      ),
    );
  }
}
