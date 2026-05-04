import 'package:equatable/equatable.dart';

enum ClassType {
  k12,
  competitive,
  other;

  static ClassType fromString(String type) {
    return ClassType.values.firstWhere(
      (e) => e.toString().split('.').last == type,
      orElse: () => ClassType.other,
    );
  }
}

class SchoolClass extends Equatable {
  final String id;
  final String name; 
  final ClassType type;

  const SchoolClass({
    required this.id,
    required this.name,
    required this.type,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ClassType.fromString(json['type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
    };
  }

  @override
  List<Object?> get props => [id, name, type];
}

class Subject extends Equatable {
  final String id;
  final String name;
  final List<String> classIds;
  final String? teacherId;
  final bool isActive;

  const Subject({
    required this.id,
    required this.name,
    this.classIds = const [],
    this.teacherId,
    this.isActive = true,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      name: json['name'] as String,
      classIds: (json['class_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      teacherId: json['teacher_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'class_ids': classIds,
      'teacher_id': teacherId,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [id, name, classIds, teacherId, isActive];
}

class LearningModule extends Equatable {
  final String id;
  final String subjectId;
  final String classId;
  final String name;
  final DateTime createdAt;

  const LearningModule({
    required this.id,
    required this.subjectId,
    required this.classId,
    required this.name,
    required this.createdAt,
  });

  factory LearningModule.fromJson(Map<String, dynamic> json) {
    return LearningModule(
      id: json['id'] as String,
      subjectId: json['subject_id'] as String,
      classId: json['class_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'class_id': classId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, subjectId, classId, name, createdAt];
}

class ClassContent extends Equatable {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final String? videoUrl;
  final String? pdfUrl;
  final String? assignment;
  final String? quiz;
  final String duration;
  final List<String> attachments;
  final List<String> tags;

  const ClassContent({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
    this.assignment,
    this.quiz,
    required this.duration,
    this.attachments = const [],
    this.tags = const [],
  });

  factory ClassContent.fromJson(Map<String, dynamic> json) {
    return ClassContent(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['video_url'] as String?,
      pdfUrl: json['pdf_url'] as String?,
      assignment: json['assignment'] as String?,
      quiz: json['quiz'] as String?,
      duration: json['duration'] as String,
      attachments: (json['attachments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'pdf_url': pdfUrl,
      'assignment': assignment,
      'quiz': quiz,
      'duration': duration,
      'attachments': attachments,
      'tags': tags,
    };
  }

  @override
  List<Object?> get props => [id, moduleId, title, description, videoUrl, pdfUrl, assignment, quiz, duration, attachments, tags];
}
