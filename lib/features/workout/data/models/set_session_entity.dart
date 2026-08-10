import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';

class SetSessionModel extends SetSessionEntity {
  const SetSessionModel({
    required super.setSessionId,
    required super.workoutSessionId,
    required super.exerciseId,
    required super.setNumber,
    super.repsPerformed,
    super.weight,
    super.isCompleted,
  });

  factory SetSessionModel.fromJson(Map<String, dynamic> json) {
    return SetSessionModel(
      setSessionId: json['set_session_id'] as String,
      workoutSessionId: json['workout_session_id'] as int,
      exerciseId: json['exercise_id'] as int,
      setNumber: json['set_number'] as int,
      repsPerformed: json['reps_performed'] as int?,
      weight: _toDouble(json['weight']),
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'set_session_id': setSessionId,
      'workout_session_id': workoutSessionId,
      'exercise_id': exerciseId,
      'set_number': setNumber,
      'reps_performed': repsPerformed,
      'weight': weight,
      'is_completed': isCompleted,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'workout_session_id': workoutSessionId,
      'exercise_id': exerciseId,
      'set_number': setNumber,
      'reps_performed': repsPerformed,
      'weight': weight,
      'is_completed': isCompleted,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      'workout_session_id': workoutSessionId,
      'exercise_id': exerciseId,
      'set_number': setNumber,
      'reps_performed': repsPerformed,
      'weight': weight,
      'is_completed': isCompleted,
    };
  }

  factory SetSessionModel.fromEntity(SetSessionEntity entity) {
    return SetSessionModel(
      setSessionId: entity.setSessionId,
      workoutSessionId: entity.workoutSessionId,
      exerciseId: entity.exerciseId,
      setNumber: entity.setNumber,
      repsPerformed: entity.repsPerformed,
      weight: entity.weight,
      isCompleted: entity.isCompleted,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}