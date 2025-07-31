//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules  
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/models/modules.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

// AuthService class handles authentication and user data management
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  // Getter to access the currently authenticated user
  User? get currentUser => _auth.currentUser;

  // Method to log in a user with email and password
  Future<User?> login(String email, String password) async {
    try {
      // Sign in the user with email and password
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Return the signed-in user
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code); // Handle authentication errors
    }
  }

  // Method to register a new user
  Future<User?> register(String email, String password, String name) async {
    try {
      // Create a new user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create an AppUser object with additional user data
      AppUser appUser = AppUser(
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      // Save the user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(appUser.toFirestore());
      
      return userCredential.user; // Return the newly created user
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code); // Handle authentication errors
    }
  }

  // Method to handle authentication errors
  String _authError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid CUT email address'; // Custom error message for invalid email
      case 'weak-password':
        return 'Password must be 8+ chars with @ symbol'; // Custom error message for weak password
      default:
        return 'Authentication failed'; // Default error message
    }
  }

  // Method to get user data from Firestore
  Future<AppUser?> getUserData(String uid) async {
    // Fetch the document from Firestore
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      // Convert the document data to an AppUser object
      return AppUser.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null; // Return null if the document does not exist
  }

   // Module Collection Reference
  CollectionReference get _modulesCollection => _firestore.collection('modules');

  // Add a new module
  Future<void> addModule(String name, String code) async {
    if (currentUser == null) throw Exception('User not authenticated');
    
    await _modulesCollection.add({
      'name': name,// Store the module name
      'code': code,// Store the module code
      'studentId': currentUser!.uid,// Store the current user's ID from Firebase Auth 
      'createdAt': DateTime.now(),// Store the current date and time
    });
    notifyListeners();
  }

  // Update a module
  Future<void> updateModule(String moduleId, String name, String code) async {
    await _modulesCollection.doc(moduleId).update({
      'name': name,
      'code': code,
    });
    notifyListeners();
  }

  // Delete a module
  Future<void> deleteModule(String moduleId) async {
    await _modulesCollection.doc(moduleId).delete();
    notifyListeners();
  }

  // Get all modules for current user
  Stream<List<Module>> getModules() {
    if (currentUser == null) throw Exception('User not authenticated');
    // Listen to the modules collection for the current user
    // and order by createdAt in descending order
    // Map the snapshot to a list of Module objects
    // using the fromFirestore method
    // and return the list as a stream
    // This allows real-time updates to the module list
    // whenever there are changes in the Firestore collection
    // The stream will emit a new list of modules whenever there are changes
    return _modulesCollection
      .where('studentId', isEqualTo: currentUser!.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => 
        snapshot.docs.map((doc) => Module.fromFirestore(doc)).toList());
  }
}
