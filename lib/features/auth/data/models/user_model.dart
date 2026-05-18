import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
  });

  factory UserModel.fromSupabaseUser(User user, {String? username}) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: username ?? user.userMetadata?['username'] as String?,
    );
  }

  factory UserModel.empty() => const UserModel(id: '', email: '');
}