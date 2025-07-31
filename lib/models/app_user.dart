//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules  
//

// This class represents a user in the application.
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email; // User's email address
  final String name; // User's name
  final DateTime createdAt; // Timestamp of when the user was created

  // Constructor to initialize the AppUser object
  AppUser({
    required this.email,
    required this.name,
    required this.createdAt,
  });

  // Factory method to create an AppUser from Firestore document data
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      email: data['email'],
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert AppUser to a Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'createdAt': createdAt,
    };
  }
}
// This class is used to represent a user in the application. It contains fields for the user's email, name, and the date they were created.
// The class provides a factory method to create an instance from Firestore document data and a method to convert the instance back to a format suitable for Firestore storage.
// This allows for easy serialization and deserialization of user data when interacting with Firestore, ensuring that the data is stored and retrieved correctly.
// The class is designed to be used in conjunction with Firebase Authentication and Firestore, making it a crucial part of the user management system in the application.
// The AppUser class is essential for managing user data and ensuring that the application can effectively handle user authentication and storage.
//     return 'An error occurred. Please try again.'; // Generic error message for other cases

