import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String userId;
  final String username;
  final double height;
  final double weight;
  final String? avatar;

  const ProfileEntity({
    required this.userId,
    required this.username,
    required this.height,
    required this.weight,
    this.avatar,
  });

  ProfileEntity copyWith({
    String? userId,
    String? username,
    double? height,
    double? weight,
    String? avatar,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userId, username, height, weight, avatar];
}
