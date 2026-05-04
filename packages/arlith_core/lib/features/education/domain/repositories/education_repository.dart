import 'package:arlith_core/models/education_models.dart';

abstract class EducationRepository {
  // Classes
  Future<List<SchoolClass>> getClasses();
  Future<void> addClass(SchoolClass schoolClass);
  Future<void> deleteClass(String id);
  
  // Subjects
  Future<List<Subject>> getSubjects(String? classId);
  Future<void> addSubject(Subject subject);
  Future<void> updateSubject(Subject subject);
  Future<void> deleteSubject(String id);
  Future<void> assignSubjectToTeacher(String subjectId, String teacherId);
  
  // Modules
  Future<List<LearningModule>> getModules(String subjectId, String classId);
  Future<void> addModule(LearningModule module);
  Future<void> deleteModule(String id);
  
  // Class Content
  Future<List<ClassContent>> getClassContent(String moduleId);
  Future<void> addClassContent(ClassContent content);
  Future<void> deleteClassContent(String id);
}
