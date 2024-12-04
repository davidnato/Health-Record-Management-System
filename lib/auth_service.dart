import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login method
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  // Register method
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set default role after registration
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'role': 'Admin', // Default role for new users
      });

      return result.user;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  // Get user role from Firestore
  Future<String> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          var role = userDoc['role'];
          if (role != null) {
            return role;
          } else {
            print("Role field is missing in Firestore for user: ${user.uid}");
            return ''; // Return empty if role is missing
          }
        } else {
          print("No user document found in Firestore for user: ${user.uid}");
          return ''; // Return empty if user document is missing
        }
      } catch (e) {
        print("Error retrieving user role: $e");
        return ''; // Return empty on error
      }
    }
    return ''; // Return empty if no user is logged in
  }

  // Logout method
  Future<void> logout() async {
    await _auth.signOut();
  }
}
