import 'package:dartz/dartz.dart';
import 'package:arlith_core/models/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, UserProfile>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> signInWithPhone(String phone) async {
    try {
      await remoteDataSource.signInWithPhone(phone);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Option<UserProfile>>> verifyOTP(String phone, String token) async {
    try {
      final user = await remoteDataSource.verifyOTP(phone, token);
      return Right(optionOf(user));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserProfile>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        phone: phone,
      );
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> logout() => remoteDataSource.logout();

  @override
  Future<Either<String, UserProfile>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) return Right(user);
      return const Left('No user logged in');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<UserProfile?> get authStateChanges => remoteDataSource.authStateChanges;
}
