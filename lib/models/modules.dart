//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules  
//

import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String id;
  final String name;
  final String code;
  final String studentId;
  final DateTime createdAt;

  Module({
    required this.id,
    required this.name,
    required this.code,
    required this.studentId,
    required this.createdAt,
  });

  factory Module.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Module(
      id: doc.id,
      name: data['name'],
      code: data['code'],
      studentId: data['studentId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
    // Note: Ensure that the 'createdAt' field is a Timestamp in Firestore
    // and that you have the necessary imports for Timestamp.
    // If 'createdAt' is not a Timestamp, you may need to adjust the conversion accordingly.
    // For example, if it's a DateTime, you can directly use it without conversion.
    // If it's a String, you may need to parse it into a DateTime object.
    // Also, ensure that the 'studentId' field is present in the Firestore document.
    // If it's not present, you may need to handle it accordingly (e.g., set a default value).
    // Additionally, consider adding error handling for cases where the document
    // does not exist or the data is not in the expected format.
    // You may also want to check if the 'name', 'code', and 'studentId' fields
    // are present in the data map before accessing them to avoid potential null errors.
    // You can use the null-aware operator (?.) or provide default values
    // to handle cases where these fields might be missing.

  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'code': code,
      'studentId': studentId,
      'createdAt': createdAt,
    };
  }
}