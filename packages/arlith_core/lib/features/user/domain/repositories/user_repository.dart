import 'package:arlith_core/models/user_profile.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<String, List<UserProfile>>> getAllUsers();
  Future<Either<String, List<UserProfile>>> getPendingTeachers();
  Future<Either<String, Unit>> approveTeacher(String userId);
  Future<Either<String, Unit>> assignStudentToTeacher(String studentId, String teacherId);
  Future<Either<String, Unit>> assignStudentToParent(String studentId, String parentId);
  Future<Either<String, List<UserProfile>>> getUsersByRole(String role);
  Future<Either<String, Unit>> updateUserProfile(UserProfile user);
  Future<Either<String, Unit>> assignStudentToClass(String studentId, String classId);
  Future<Either<String, Unit>> assignUserToSubjects(String userId, List<String> subjectIds);
}
