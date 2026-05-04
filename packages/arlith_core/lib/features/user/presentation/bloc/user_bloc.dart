import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arlith_core/features/user/domain/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<LoadPendingTeachers>(_onLoadPendingTeachers);
    on<ApproveTeacherRequested>(_onApproveTeacherRequested);
    on<LoadUsersByRole>(_onLoadUsersByRole);
    on<AssignStudentToTeacherRequested>(_onAssignStudentToTeacherRequested);
    on<AssignStudentToParentRequested>(_onAssignStudentToParentRequested);
    on<UpdateUserProfileRequested>(_onUpdateUserProfileRequested);
    on<AssignStudentToClassRequested>(_onAssignStudentToClassRequested);
    on<AssignUserToSubjectsRequested>(_onAssignUserToSubjectsRequested);
  }

  Future<void> _onLoadAllUsers(LoadAllUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.getAllUsers();
    result.fold(
      (error) => emit(UserError(error)),
      (users) => emit(UsersLoaded(users)),
    );
  }

  Future<void> _onLoadPendingTeachers(LoadPendingTeachers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.getPendingTeachers();
    result.fold(
      (error) => emit(UserError(error)),
      (users) => emit(UsersLoaded(users)),
    );
  }

  Future<void> _onApproveTeacherRequested(ApproveTeacherRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.approveTeacher(event.userId);
    result.fold(
      (error) => emit(UserError(error)),
      (_) {
        emit(TeacherApproved());
        add(LoadPendingTeachers());
      },
    );
  }

  Future<void> _onLoadUsersByRole(LoadUsersByRole event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.getUsersByRole(event.role);
    result.fold(
      (error) => emit(UserError(error)),
      (users) => emit(UsersLoaded(users)),
    );
  }

  Future<void> _onAssignStudentToTeacherRequested(AssignStudentToTeacherRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.assignStudentToTeacher(event.studentId, event.teacherId);
    result.fold(
      (error) => emit(UserError(error)),
      (_) => emit(UserActionSuccess('Student assigned to teacher successfully')),
    );
  }

  Future<void> _onAssignStudentToParentRequested(AssignStudentToParentRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.assignStudentToParent(event.studentId, event.parentId);
    result.fold(
      (error) => emit(UserError(error)),
      (_) => emit(UserActionSuccess('Student assigned to parent successfully')),
    );
  }

  Future<void> _onUpdateUserProfileRequested(UpdateUserProfileRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.updateUserProfile(event.user);
    result.fold(
      (error) => emit(UserError(error)),
      (_) {
        emit(UserActionSuccess('Profile updated successfully'));
        add(LoadAllUsers());
      },
    );
  }

  Future<void> _onAssignStudentToClassRequested(AssignStudentToClassRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.assignStudentToClass(event.studentId, event.classId);
    result.fold(
      (error) => emit(UserError(error)),
      (_) => emit(UserActionSuccess('Class assigned successfully')),
    );
  }

  Future<void> _onAssignUserToSubjectsRequested(AssignUserToSubjectsRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _userRepository.assignUserToSubjects(event.userId, event.subjectIds);
    result.fold(
      (error) => emit(UserError(error)),
      (_) => emit(UserActionSuccess('Subjects assigned successfully')),
    );
  }
}
