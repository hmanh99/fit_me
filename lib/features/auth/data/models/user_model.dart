import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
  });

  factory UserModel.fromFirebaseUser(User user, {String? username}) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: username ?? user.displayName,
    );
  }

  factory UserModel.empty() => const UserModel(id: '', email: '');
}