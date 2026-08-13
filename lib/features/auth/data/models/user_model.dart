import 'package:fit_me/features/auth/domain/entities/user_entities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email, super.name});

  factory UserModel.fromJson(User user, {String? username}) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: username ?? user.userMetadata?['username'] as String?,
    );
  }

  UserEntity toEntity() {
    return UserEntity(id: id, email: email, name: name, );
  }

  factory UserModel.empty() => const UserModel(id: '', email: '');
}
