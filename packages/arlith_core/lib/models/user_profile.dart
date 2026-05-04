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

  const UserProfile({
    required this.id,
    required this.email,
    this.phone,
    required this.fullName,
    required this.role,
    this.isApproved = false,
    required this.createdAt,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'role': role.name,
      'is_approved': isApproved,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, email, phone, fullName, role, isApproved, createdAt];
}
