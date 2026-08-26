import 'package:equatable/equatable.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  ProfileEntity? get profile => null;

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {
  @override
  final ProfileEntity profile;

  const ProfileUpdating({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileAvatarUploading extends ProfileState {
  @override
  final ProfileEntity profile;

  const ProfileAvatarUploading({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileLoaded extends ProfileState {
  @override
  final ProfileEntity profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileLogoutSuccess extends ProfileState {
  const ProfileLogoutSuccess();

  @override
  List<Object?> get props => [];
}

class ProfileLogoutFailure extends ProfileState {
  const ProfileLogoutFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}