import 'package:equatable/equatable.dart';
import 'package:arlith_core/models/user_profile.dart';

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

class LoadUsersByRole extends UserEvent {
  final String role;
  LoadUsersByRole(this.role);
  @override
  List<Object?> get props => [role];
}

class AssignStudentToTeacherRequested extends UserEvent {
  final String studentId;
  final String teacherId;
  AssignStudentToTeacherRequested({required this.studentId, required this.teacherId});
  @override
  List<Object?> get props => [studentId, teacherId];
}

class AssignStudentToParentRequested extends UserEvent {
  final String studentId;
  final String parentId;
  AssignStudentToParentRequested({required this.studentId, required this.parentId});
  @override
  List<Object?> get props => [studentId, parentId];
}

class UpdateUserProfileRequested extends UserEvent {
  final UserProfile user;
  UpdateUserProfileRequested(this.user);
  @override
  List<Object?> get props => [user];
}

class AssignStudentToClassRequested extends UserEvent {
  final String studentId;
  final String classId;
  AssignStudentToClassRequested({required this.studentId, required this.classId});
  @override
  List<Object?> get props => [studentId, classId];
}

class AssignUserToSubjectsRequested extends UserEvent {
  final String userId;
  final List<String> subjectIds;
  AssignUserToSubjectsRequested({required this.userId, required this.subjectIds});
  @override
  List<Object?> get props => [userId, subjectIds];
}
