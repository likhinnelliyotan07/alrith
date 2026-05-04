import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<PhoneSignInRequested>(_onPhoneSignInRequested);
    on<OTPVerificationRequested>(_onOTPVerificationRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final result = await _authRepository.getCurrentUser();
    result.fold((_) => emit(Unauthenticated()), (user) => emit(Authenticated(user)));
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.login(event.email, event.password);
    result.fold((error) => emit(AuthError(error)), (user) => emit(Authenticated(user)));
  }

  Future<void> _onPhoneSignInRequested(PhoneSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithPhone(event.phone);
    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(OTPCodeSent(event.phone)),
    );
  }

  Future<void> _onOTPVerificationRequested(OTPVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.verifyOTP(event.phone, event.otp);
    result.fold(
      (error) => emit(AuthError(error)),
      (userOption) => userOption.fold(
        () => emit(NeedsRegistration(phone: event.phone)),
        (user) => emit(Authenticated(user)),
      ),
    );
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.signUp(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      role: event.role,
      phone: event.phone,
    );
    result.fold((error) => emit(AuthError(error)), (user) => emit(Authenticated(user)));
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
