import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetched extends ProfileEvent {
  final String userId;

  const ProfileFetched({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String? username;
  final double? height;
  final double? weight;
  final String? avatar;

  const ProfileUpdateRequested({
    this.username,
    this.height,
    this.weight,
    this.avatar,
  });

  @override
  List<Object?> get props => [username, height, weight, avatar];
}

class ProfileLogoutEvent extends ProfileEvent {
  const ProfileLogoutEvent();

  @override
  List<Object?> get props => [];
}