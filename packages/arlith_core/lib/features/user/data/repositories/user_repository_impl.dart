import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';
import '../../../../models/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _client;

  UserRepositoryImpl(this._client);

  @override
  Future<Either<String, List<UserProfile>>> getAllUsers() async {
    try {
      final response = await _client.from('profiles').select();
      final users = (response as List).map((e) => UserProfile.fromJson(e)).toList();
      return Right(users);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<UserProfile>>> getPendingTeachers() async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('role', 'teacher')
          .eq('is_approved', false);
      final users = (response as List).map((e) => UserProfile.fromJson(e)).toList();
      return Right(users);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> approveTeacher(String userId) async {
    try {
      await _client
          .from('profiles')
          .update({'is_approved': true})
          .eq('id', userId);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> assignStudentToTeacher(String studentId, String teacherId) async {
    try {
      await _client.from('teacher_student_mapping').upsert({
        'teacher_id': teacherId,
        'student_id': studentId,
      });
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> assignStudentToParent(String studentId, String parentId) async {
    try {
      await _client.from('parent_student_mapping').upsert({
        'parent_id': parentId,
        'student_id': studentId,
      });
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
