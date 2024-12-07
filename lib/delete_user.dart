import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({super.key});

  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch all users from Firestore
  Future<void> _fetchUsers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final users = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      setState(() {
        _users = users;
        _filteredUsers = users;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  // Filter users based on search query
  void _filterUsers(String query) {
    final filtered = _users
        .where((user) =>
            user['fullName'].toString().toLowerCase().contains(query.toLowerCase()) ||
            user['email'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredUsers = filtered;
    });
  }

  // Delete a user from Firestore
  Future<void> _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User deleted successfully!")),
      );
      _fetchUsers(); // Refresh the user list
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete User"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: "Search User",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 20),
                suffixIcon: Icon(Icons.search, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),

            // User List
            Expanded(
              child: _filteredUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              user['fullName'] ?? 'Unknown',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email: ${user['email']}"),
                                Text("Role: ${user['role'] ?? 'Not Assigned'}"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmation(user['id']);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No users found.",
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Show confirmation dialog before deleting a user
  void _showDeleteConfirmation(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(userId);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
