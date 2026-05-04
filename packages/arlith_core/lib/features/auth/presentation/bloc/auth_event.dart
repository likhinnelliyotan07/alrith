import 'package:equatable/equatable.dart';


abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class PhoneSignInRequested extends AuthEvent {
  final String phone;
  PhoneSignInRequested(this.phone);
  @override
  List<Object?> get props => [phone];
}

class OTPVerificationRequested extends AuthEvent {
  final String phone;
  final String otp;
  OTPVerificationRequested(this.phone, this.otp);
  @override
  List<Object?> get props => [phone, otp];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;
  final String? phone;

  SignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, fullName, role, phone];
}

class LogoutRequested extends AuthEvent {}
