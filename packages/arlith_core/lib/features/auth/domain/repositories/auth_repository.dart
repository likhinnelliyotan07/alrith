import 'package:dartz/dartz.dart';
import 'package:arlith_core/models/user_profile.dart';

abstract class AuthRepository {
  Future<Either<String, UserProfile>> login(String email, String password);
  Future<Either<String, Unit>> signInWithPhone(String phone);
  Future<Either<String, Option<UserProfile>>> verifyOTP(String phone, String token);
  Future<Either<String, UserProfile>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
  });
  Future<void> logout();
  Future<Either<String, UserProfile>> getCurrentUser();
  Stream<UserProfile?> get authStateChanges;
}
