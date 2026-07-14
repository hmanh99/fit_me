enum MealType {
  breakfast,
  lunch,
  dinner;

  /// Convert from the Supabase snake_case string to enum.
  static MealType fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'breakfast':
        return MealType.breakfast;
      case 'lunch':
        return MealType.lunch;
      case 'dinner':
        return MealType.dinner;
      default:
        return MealType.breakfast;
    }
  }

  /// Convert to the Supabase snake_case string.
  String toDbString() {
    switch (this) {
      case MealType.breakfast:
        return 'breakfast';
      case MealType.lunch:
        return 'lunch';
      case MealType.dinner:
        return 'dinner';
    }
  }

  /// Human-readable label for the UI.
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
    }
  }
}
