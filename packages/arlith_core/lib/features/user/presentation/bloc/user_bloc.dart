import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<LoadPendingTeachers>(_onLoadPendingTeachers);
    on<ApproveTeacherRequested>(_onApproveTeacherRequested);
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
}
