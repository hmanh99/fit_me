import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
  });

  factory UserModel.empty() => const UserModel(id: '', email: '');

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [id, email, name];
}