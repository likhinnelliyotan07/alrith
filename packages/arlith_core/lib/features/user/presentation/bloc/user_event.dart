import 'package:equatable/equatable.dart';
import '../../../../models/user_profile.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllUsers extends UserEvent {}
class LoadPendingTeachers extends UserEvent {}
class ApproveTeacherRequested extends UserEvent {
  final String userId;
  ApproveTeacherRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
