import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arlith_core/models/education_models.dart';
import 'package:arlith_core/features/education/domain/repositories/education_repository.dart';

class EducationRepositoryImpl implements EducationRepository {
  final SupabaseClient _supabase;

  EducationRepositoryImpl(this._supabase);

  // In-memory dummy data for local testing fallback and DB seeding
  final List<SchoolClass> _dummyClasses = [
    const SchoolClass(id: '1', name: 'Class 1', type: ClassType.k12),
    const SchoolClass(id: '10', name: 'Class 10', type: ClassType.k12),
    const SchoolClass(id: '12', name: 'Class 12', type: ClassType.k12),
    const SchoolClass(id: 'psc', name: 'PSC', type: ClassType.competitive),
    const SchoolClass(id: 'ssc', name: 'SSC', type: ClassType.competitive),
    const SchoolClass(id: 'rrb', name: 'RRB', type: ClassType.competitive),
  ];

  final List<Subject> _dummySubjects = [
    const Subject(id: 'math', name: 'Mathematics', classIds: ['10', '1']),
    const Subject(id: 'science', name: 'Science', classIds: ['10']),
    const Subject(id: 'gk', name: 'General Knowledge', classIds: ['psc']),
    const Subject(id: 'english', name: 'English', classIds: ['ssc']),
  ];

  final List<LearningModule> _dummyModules = [
    LearningModule(id: 'mod1', subjectId: 'math', classId: '10', name: 'Algebra Basics', createdAt: DateTime.now()),
    LearningModule(id: 'mod2', subjectId: 'math', classId: '10', name: 'Calculus Introduction', createdAt: DateTime.now()),
  ];

  final List<ClassContent> _dummyContent = [
    const ClassContent(
      id: 'cont1',
      moduleId: 'mod1',
      title: 'Introduction to Equations',
      description: 'Learn the basics of solving linear equations.',
      duration: '45 mins',
      videoUrl: 'https://example.com/video1',
    ),
  ];

  @override
  Future<List<SchoolClass>> getClasses() async {
    try {
      final response = await _supabase.from('classes').select();
      final list = (response as List).map((json) => SchoolClass.fromJson(json)).toList();
      if (list.isEmpty) {
        await _seedClasses();
        return _dummyClasses;
      }
      return list;
    } catch (e) {
      return _dummyClasses;
    }
  }

  Future<void> _seedClasses() async {
    for (var c in _dummyClasses) {
      await _supabase.from('classes').insert(c.toJson());
    }
  }

  @override
  Future<List<Subject>> getSubjects(String? classId) async {
    try {
      var query = _supabase.from('subjects').select();
      final response = await query;
      var list = (response as List).map((json) => Subject.fromJson(json)).toList();
      
      if (list.isEmpty) {
        await _seedSubjects();
        list = _dummySubjects;
      }

      if (classId != null) {
        return list.where((s) => s.classIds.contains(classId)).toList();
      }
      return list;
    } catch (e) {
      if (classId != null) {
        return _dummySubjects.where((s) => s.classIds.contains(classId)).toList();
      }
      return _dummySubjects;
    }
  }

  Future<void> _seedSubjects() async {
    for (var s in _dummySubjects) {
      await _supabase.from('subjects').insert(s.toJson());
    }
  }

  @override
  Future<void> addClass(SchoolClass schoolClass) async {
    try {
      await _supabase.from('classes').insert(schoolClass.toJson());
    } catch (e) {
      _dummyClasses.add(schoolClass);
    }
  }

  @override
  Future<void> addSubject(Subject subject) async {
    try {
      await _supabase.from('subjects').insert(subject.toJson());
    } catch (e) {
      _dummySubjects.add(subject);
    }
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    try {
      await _supabase.from('subjects').update(subject.toJson()).eq('id', subject.id);
    } catch (e) {
      final index = _dummySubjects.indexWhere((s) => s.id == subject.id);
      if (index != -1) _dummySubjects[index] = subject;
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      await _supabase.from('classes').delete().eq('id', id);
    } catch (e) {
      _dummyClasses.removeWhere((c) => c.id == id);
    }
  }

  @override
  Future<void> deleteSubject(String id) async {
    try {
      await _supabase.from('subjects').delete().eq('id', id);
    } catch (e) {
      _dummySubjects.removeWhere((s) => s.id == id);
    }
  }

  @override
  Future<void> assignSubjectToTeacher(String subjectId, String teacherId) async {
    try {
      await _supabase.from('subjects').update({'teacher_id': teacherId}).eq('id', subjectId);
    } catch (e) {
      final index = _dummySubjects.indexWhere((s) => s.id == subjectId);
      if (index != -1) {
        final s = _dummySubjects[index];
        _dummySubjects[index] = Subject(
          id: s.id,
          name: s.name,
          classIds: s.classIds,
          teacherId: teacherId,
          isActive: s.isActive,
        );
      }
    }
  }

  @override
  Future<List<LearningModule>> getModules(String subjectId, String classId) async {
    try {
      final response = await _supabase.from('modules').select()
          .eq('subject_id', subjectId)
          .eq('class_id', classId);
      final list = (response as List).map((json) => LearningModule.fromJson(json)).toList();
      if (list.isEmpty && subjectId == 'math') {
        await _seedModules();
        return _dummyModules;
      }
      return list;
    } catch (e) {
      return _dummyModules.where((m) => m.subjectId == subjectId && m.classId == classId).toList();
    }
  }

  Future<void> _seedModules() async {
    for (var m in _dummyModules) {
      await _supabase.from('modules').insert(m.toJson());
    }
  }

  @override
  Future<void> addModule(LearningModule module) async {
    try {
      await _supabase.from('modules').insert(module.toJson());
    } catch (e) {
      _dummyModules.add(module);
    }
  }

  @override
  Future<void> deleteModule(String id) async {
    try {
      await _supabase.from('modules').delete().eq('id', id);
    } catch (e) {
      _dummyModules.removeWhere((m) => m.id == id);
    }
  }

  @override
  Future<List<ClassContent>> getClassContent(String moduleId) async {
    try {
      final response = await _supabase.from('contents').select().eq('module_id', moduleId);
      final list = (response as List).map((json) => ClassContent.fromJson(json)).toList();
      if (list.isEmpty && moduleId == 'mod1') {
        await _seedContent();
        return _dummyContent;
      }
      return list;
    } catch (e) {
      return _dummyContent.where((c) => c.moduleId == moduleId).toList();
    }
  }

  Future<void> _seedContent() async {
    for (var c in _dummyContent) {
      await _supabase.from('contents').insert(c.toJson());
    }
  }

  @override
  Future<void> addClassContent(ClassContent content) async {
    try {
      await _supabase.from('contents').insert(content.toJson());
    } catch (e) {
      _dummyContent.add(content);
    }
  }

  @override
  Future<void> deleteClassContent(String id) async {
    try {
      await _supabase.from('contents').delete().eq('id', id);
    } catch (e) {
      _dummyContent.removeWhere((c) => c.id == id);
    }
  }
}
