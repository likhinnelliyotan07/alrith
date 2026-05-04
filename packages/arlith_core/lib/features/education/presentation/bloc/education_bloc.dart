import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:arlith_core/features/education/domain/repositories/education_repository.dart';
import 'package:arlith_core/models/education_models.dart';

// Events
abstract class EducationEvent extends Equatable {
  const EducationEvent();
  @override
  List<Object?> get props => [];
}

class LoadEducationData extends EducationEvent {}

class LoadModulesEvent extends EducationEvent {
  final String subjectId;
  final String classId;
  const LoadModulesEvent(this.subjectId, this.classId);
}

class LoadClassContentEvent extends EducationEvent {
  final String moduleId;
  const LoadClassContentEvent(this.moduleId);
}

class AddClassEvent extends EducationEvent {
  final SchoolClass schoolClass;
  const AddClassEvent(this.schoolClass);
}

class AddSubjectEvent extends EducationEvent {
  final Subject subject;
  const AddSubjectEvent(this.subject);
}

class UpdateSubjectEvent extends EducationEvent {
  final Subject subject;
  const UpdateSubjectEvent(this.subject);
}

class AddModuleEvent extends EducationEvent {
  final LearningModule module;
  const AddModuleEvent(this.module);
}

class AddClassContentEvent extends EducationEvent {
  final ClassContent content;
  const AddClassContentEvent(this.content);
}

class AssignSubjectToTeacherEvent extends EducationEvent {
  final String subjectId;
  final String teacherId;
  const AssignSubjectToTeacherEvent(this.subjectId, this.teacherId);
}

// States
abstract class EducationState extends Equatable {
  const EducationState();
  @override
  List<Object?> get props => [];
}

class EducationInitial extends EducationState {}

class EducationLoading extends EducationState {}

class EducationLoaded extends EducationState {
  final List<SchoolClass> classes;
  final List<Subject> subjects;
  final List<LearningModule> modules;
  final List<ClassContent> contents;

  const EducationLoaded({
    this.classes = const [],
    this.subjects = const [],
    this.modules = const [],
    this.contents = const [],
  });

  EducationLoaded copyWith({
    List<SchoolClass>? classes,
    List<Subject>? subjects,
    List<LearningModule>? modules,
    List<ClassContent>? contents,
  }) {
    return EducationLoaded(
      classes: classes ?? this.classes,
      subjects: subjects ?? this.subjects,
      modules: modules ?? this.modules,
      contents: contents ?? this.contents,
    );
  }

  @override
  List<Object?> get props => [classes, subjects, modules, contents];
}

class EducationError extends EducationState {
  final String message;
  const EducationError(this.message);
}

// Bloc
class EducationBloc extends Bloc<EducationEvent, EducationState> {
  final EducationRepository _repository;

  EducationBloc(this._repository) : super(EducationInitial()) {
    on<LoadEducationData>((event, emit) async {
      emit(EducationLoading());
      try {
        final classes = await _repository.getClasses();
        final subjects = await _repository.getSubjects(null);
        emit(EducationLoaded(classes: classes, subjects: subjects));
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });

    on<LoadModulesEvent>((event, emit) async {
      final currentState = state;
      if (currentState is EducationLoaded) {
        try {
          final modules = await _repository.getModules(event.subjectId, event.classId);
          emit(currentState.copyWith(modules: modules));
        } catch (e) {
          emit(EducationError(e.toString()));
        }
      }
    });

    on<LoadClassContentEvent>((event, emit) async {
      final currentState = state;
      if (currentState is EducationLoaded) {
        try {
          final contents = await _repository.getClassContent(event.moduleId);
          emit(currentState.copyWith(contents: contents));
        } catch (e) {
          emit(EducationError(e.toString()));
        }
      }
    });

    on<AddClassEvent>((event, emit) async {
      try {
        await _repository.addClass(event.schoolClass);
        add(LoadEducationData());
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });

    on<AddSubjectEvent>((event, emit) async {
      try {
        await _repository.addSubject(event.subject);
        add(LoadEducationData());
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });

    on<UpdateSubjectEvent>((event, emit) async {
      try {
        await _repository.updateSubject(event.subject);
        add(LoadEducationData());
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });

    on<AddModuleEvent>((event, emit) async {
      try {
        await _repository.addModule(event.module);
        add(LoadModulesEvent(event.module.subjectId, event.module.classId));
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });

    on<AddClassContentEvent>((event, emit) async {
      try {
        await _repository.addClassContent(event.content);
        add(LoadClassContentEvent(event.content.moduleId));
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });

    on<AssignSubjectToTeacherEvent>((event, emit) async {
      try {
        await _repository.assignSubjectToTeacher(event.subjectId, event.teacherId);
        add(LoadEducationData());
      } catch (e) {
        emit(EducationError(e.toString()));
      }
    });
  }
}
