import 'package:arlith_core/models/user_profile.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<String, List<UserProfile>>> getAllUsers();
  Future<Either<String, List<UserProfile>>> getPendingTeachers();
  Future<Either<String, Unit>> approveTeacher(String userId);
  Future<Either<String, Unit>> assignStudentToTeacher(String studentId, String teacherId);
  Future<Either<String, Unit>> assignStudentToParent(String studentId, String parentId);
}
