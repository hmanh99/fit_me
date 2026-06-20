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

class ProfileUsernameUpdated extends ProfileEvent {
  final String username;

  const ProfileUsernameUpdated({required this.username});

  @override
  List<Object?> get props => [username];
}

class ProfileHeightUpdated extends ProfileEvent {
  final double height;

  const ProfileHeightUpdated({required this.height});

  @override
  List<Object?> get props => [height];
}

class ProfileWeightUpdated extends ProfileEvent {
  final double weight;

  const ProfileWeightUpdated({required this.weight});

  @override
  List<Object?> get props => [weight];
}

class ProfileAvatarUpdated extends ProfileEvent {
  final String avatar;

  const ProfileAvatarUpdated({required this.avatar});

  @override
  List<Object?> get props => [avatar];
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