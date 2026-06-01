/// Status of a workout schedule entry.
///
/// Maps directly to the Supabase `schedule_status` enum:
/// `upcoming` | `in_progress` | `done`.
enum ScheduleStatus {
  upcoming,
  inProgress,
  done;

  /// Convert from the Supabase snake_case string to enum.
  static ScheduleStatus fromString(String value) {
    switch (value) {
      case 'upcoming':
        return ScheduleStatus.upcoming;
      case 'in_progress':
        return ScheduleStatus.inProgress;
      case 'done':
        return ScheduleStatus.done;
      default:
        return ScheduleStatus.upcoming;
    }
  }

  /// Convert to the Supabase snake_case string.
  String toDbString() {
    switch (this) {
      case ScheduleStatus.upcoming:
        return 'upcoming';
      case ScheduleStatus.inProgress:
        return 'in_progress';
      case ScheduleStatus.done:
        return 'done';
    }
  }

  /// Human-readable label for the UI.
  String get label {
    switch (this) {
      case ScheduleStatus.upcoming:
        return 'Upcoming';
      case ScheduleStatus.inProgress:
        return 'In Progress';
      case ScheduleStatus.done:
        return 'Done';
    }
  }
}
