import 'package:equatable/equatable.dart';
import 'user_role.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final String fullName;
  final UserRole role;
  final bool isApproved;
  final DateTime createdAt;
  final List<String>? classIds; // For students
  final List<String>? subjectIds; // For students and teachers
  final List<String>? assignedStudentIds; // For parents and teachers

  const UserProfile({
    required this.id,
    required this.email,
    this.phone,
    required this.fullName,
    required this.role,
    this.isApproved = false,
    required this.createdAt,
    this.classIds,
    this.subjectIds,
    this.assignedStudentIds,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String,
      role: UserRole.fromString(json['role'] as String),
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      classIds: (json['class_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subjectIds: (json['subject_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
      assignedStudentIds: (json['assigned_student_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'role': role.toString().split('.').last,
      'is_approved': isApproved,
      'created_at': createdAt.toIso8601String(),
      'class_ids': classIds,
      'subject_ids': subjectIds,
      'assigned_student_ids': assignedStudentIds,
    };
  }

  @override
  List<Object?> get props => [id, email, phone, fullName, role, isApproved, createdAt, classIds, subjectIds, assignedStudentIds];
}
