import 'package:fit_me/features/schedule/domain/entities/schedule_status.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';

class WorkoutScheduleModel extends WorkoutScheduleEntity {
  const WorkoutScheduleModel({
    required super.scheduleId,
    required super.userId,
    required super.planName,
    required super.scheduleDate,
    required super.status,
    required super.createdAt,
    required super.planId,
    super.note,
  });

  factory WorkoutScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkoutScheduleModel(
      scheduleId: json['schedule_id'] as int,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as int,
      planName: json['plan_name'] as String,
      scheduleDate: DateTime.parse(json['schedule_date'] as String),
      note: json['note'] as String?,
      status: ScheduleStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'plan_id': planId,
      'plan_name': planName,
      'schedule_date': scheduleDate.toIso8601String().split('T').first,
      'note': note,
      'status': status.toDbString(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'plan_id': planId,
      'plan_name': planName,
      'schedule_date': scheduleDate.toIso8601String().split('T').first,
      'note': note,
      'status': status.toDbString(),
    };
  }

  WorkoutScheduleEntity toEntity() {
    return WorkoutScheduleEntity(
      planId: planId,
      note: note,
      scheduleId: scheduleId,
      userId: userId,
      planName: planName,
      scheduleDate: scheduleDate,
      status: status,
      createdAt: createdAt,
    );
  }

  factory WorkoutScheduleModel.fromEntity(WorkoutScheduleEntity entity) {
    return WorkoutScheduleModel(
      scheduleId: entity.scheduleId,
      userId: entity.userId,
      planId: entity.planId,
      planName: entity.planName,
      scheduleDate: entity.scheduleDate,
      note: entity.note,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
