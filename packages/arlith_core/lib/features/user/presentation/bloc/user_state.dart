import 'package:equatable/equatable.dart';
import '../../../../models/user_profile.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UsersLoaded extends UserState {
  final List<UserProfile> users;
  UsersLoaded(this.users);
  @override
  List<Object?> get props => [users];
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
  @override
  List<Object?> get props => [message];
}
class TeacherApproved extends UserState {}
