import 'package:arlith_core/models/user_profile.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final UserProfile user;
  Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}
class Unauthenticated extends AuthState {}
class OTPCodeSent extends AuthState {
  final String phone;
  OTPCodeSent(this.phone);
  @override
  List<Object?> get props => [phone];
}
class NeedsRegistration extends AuthState {
  final String? phone;
  final String? email;
  NeedsRegistration({this.phone, this.email});
  @override
  List<Object?> get props => [phone, email];
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
