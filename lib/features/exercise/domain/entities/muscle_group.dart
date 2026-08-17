enum MuscleGroup {
  chest,
  back,
  shoulders,
  arms,
  legs,
  core;

  static MuscleGroup? fromString(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final lower = value.toLowerCase().trim();

    // Chest
    if (lower.contains('chest') || lower.contains('pector')) return MuscleGroup.chest;

    // Back
    if (lower.contains('back') ||
        lower.contains('lat') ||
        lower.contains('trap') ||
        lower.contains('rhomboid') ||
        lower.contains('rear delt') ||
        lower.contains('erector')) {
      return MuscleGroup.back;
    }

    // Shoulders (check before arms since "shoulder" contains broader terms)
    if (lower.contains('shoulder') || lower.contains('delt')) return MuscleGroup.shoulders;

    // Arms (biceps, triceps, forearms)
    if (lower.contains('bicep') ||
        lower.contains('tricep') ||
        lower.contains('forearm') ||
        lower.contains('arms') ||
        lower == 'arm') {
      return MuscleGroup.arms;
    }

    // Legs (quads, hamstrings, glutes, calves, adductors, abductors)
    if (lower.contains('quad') ||
        lower.contains('hamstring') ||
        lower.contains('glut') ||
        lower.contains('calf') ||
        lower.contains('adduct') ||
        lower.contains('abduct') ||
        lower.contains('leg') ||
        lower.contains('thigh') ||
        lower.contains('hip') ||
        lower.contains('tibialis')) {
      return MuscleGroup.legs;
    }

    // Core (abs, obliques)
    if (lower.contains('ab') ||
        lower.contains('core') ||
        lower.contains('oblique') ||
        lower.contains('transvers') ||
        lower.contains('pelvic')) {
      return MuscleGroup.core;
    }

    return null;
  }

  String get translationKey => name;
}
