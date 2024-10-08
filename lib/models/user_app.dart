import 'package:cloud_firestore/cloud_firestore.dart';
abstract class UserAbstract {
  final String uid;
  final String name;
  final String displayProfile;

  UserAbstract({
    required this.uid,
    required this.name,
    required this.displayProfile,
  });

  // You can define abstract methods if needed
  Map<String, dynamic> toJson();
}

class FUsers extends UserAbstract {
  final String gender;
  final String email;
  final Timestamp dob;
  final String role;
  final String fmcToken;
  final String phoneNumber;

  FUsers({
    required super.uid,
    required super.name,
    required super.displayProfile,
    required this.gender,
    required this.email,
    required this.dob,
    required this.role,
    required this.fmcToken,
    required this.phoneNumber,
  });

  factory FUsers.fromJson(Map<String, dynamic> json) {
    return FUsers(
      uid: json['uid'],
      name: json['name'],
      displayProfile: json['displayProfile'],
      gender: json['gender']?? "",
      email: json['email']?? "",
      dob: json['dob'] ?? Timestamp.now(),
      role: json['role'] ?? "",
      fmcToken: json['fmcToken'] ?? "",
      phoneNumber:json["phoneNumber"] ?? ""
    );
  }
  factory FUsers.empty() {
    return FUsers(
      uid: '',
      name: '',
      displayProfile: '',
      gender: '',
      email: '',
      dob: Timestamp.now(), // You can decide to keep the current timestamp or any placeholder
      role: '', // Default role as 'user'
      fmcToken: '',
      phoneNumber: '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'email': email,
      'dob': dob,
      'role': role,
      'displayProfile': displayProfile,
      "fmcToken":fmcToken,
      "phoneNumber":phoneNumber
    };
  }
}
