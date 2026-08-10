import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/usecases/get_current_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/logout_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_avatar_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_height_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_username_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_weight_use_case.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_event.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentProfileUseCase _getCurrentProfile;
  final UpdateProfileUsernameUseCase _updateUsername;
  final UpdateProfileHeightUseCase _updateHeight;
  final UpdateProfileWeightUseCase _updateWeight;
  final UpdateProfileAvatarUseCase _updateAvatar;
  final UpdateProfileUseCase _updateProfile;
  final LogoutProfileUseCase _logoutProfile;

  ProfileBloc({
    required GetCurrentProfileUseCase getCurrentProfile,
    required UpdateProfileUsernameUseCase updateUsername,
    required UpdateProfileHeightUseCase updateHeight,
    required UpdateProfileWeightUseCase updateWeight,
    required UpdateProfileAvatarUseCase updateAvatar,
    required UpdateProfileUseCase updateProfile,
    required LogoutProfileUseCase logoutProfile,
  })  : _getCurrentProfile = getCurrentProfile,
        _updateUsername = updateUsername,
        _updateHeight = updateHeight,
        _updateWeight = updateWeight,
        _updateAvatar = updateAvatar,
        _updateProfile = updateProfile,
        _logoutProfile = logoutProfile,
        super(ProfileInitial()) {
    on<ProfileFetched>(_onProfileFetched);
    on<ProfileUsernameUpdated>(_onUsernameUpdated);
    on<ProfileHeightUpdated>(_onHeightUpdated);
    on<ProfileWeightUpdated>(_onWeightUpdated);
    on<ProfileAvatarUpdated>(_onAvatarUpdated);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileLogoutEvent>(_onLoggedOut);
  }

  ///helper: Get current profile
  ProfileEntity? get _currentProfile {
    final s = state;
    if (s is ProfileLoaded) return s.profile;
    if (s is ProfileUpdating) return s.profile;
    return null;
  }

  Future<void> _onProfileFetched(
    ProfileFetched event,
    Emitter<ProfileState> emit,
  ) async {
    final s = state;
    if (s is ProfileLoaded && s.profile.userId == event.userId) {
      try {
        emit(ProfileLoading());
        final profile = await _getCurrentProfile(userId: event.userId);
        emit(ProfileLoaded(profile: profile));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
        emit(ProfileLoaded(profile: s.profile));
      }
      return;
    }

    try {
      final profile = await _getCurrentProfile(userId: event.userId);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _currentProfile;
    if (current == null) return;

    final updated = current.copyWith(
      username: event.username,
      height: event.height,
      weight: event.weight,
      avatar: event.avatar,
    );

    emit(ProfileUpdating(profile: updated));
    try {
      final hasUsernameChanged =
          event.username != null && event.username != current.username;
      final hasHeightChanged = event.height != null &&
          (event.height! - current.height).abs() > 0.01;
      final hasWeightChanged = event.weight != null &&
          (event.weight! - current.weight).abs() > 0.01;
      final hasAvatarChanged =
          event.avatar != null && event.avatar != current.avatar;

      await _updateProfile(
        UpdateProfileUseCaseParams(
          profile: updated,
          updateUsername: hasUsernameChanged,
          updateHeight: hasHeightChanged,
          updateWeight: hasWeightChanged,
          updateAvatar: hasAvatarChanged,
        ),
      );
      emit(ProfileLoaded(profile: updated));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      emit(ProfileLoaded(profile: current));
    }
  }

  Future<void> _onUsernameUpdated(
    ProfileUsernameUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _currentProfile;
    if (current == null) return;

    final updated = current.copyWith(username: event.username);
    emit(ProfileUpdating(profile: updated));
    try {
      await _updateUsername(profile: updated);
      emit(ProfileLoaded(profile: updated));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      emit(ProfileLoaded(profile: current));
    }
  }

  Future<void> _onHeightUpdated(
    ProfileHeightUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _currentProfile;
    if (current == null) return;

    final updated = current.copyWith(height: event.height);
    emit(ProfileUpdating(profile: updated));
    try {
      await _updateHeight(profile: updated);
      emit(ProfileLoaded(profile: updated));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      emit(ProfileLoaded(profile: current));
    }
  }

  Future<void> _onWeightUpdated(
    ProfileWeightUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _currentProfile;
    if (current == null) return;

    final updated = current.copyWith(weight: event.weight);
    emit(ProfileUpdating(profile: updated));
    try {
      await _updateWeight(profile: updated);
      emit(ProfileLoaded(profile: updated));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      emit(ProfileLoaded(profile: current));
    }
  }

  Future<void> _onAvatarUpdated(
    ProfileAvatarUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _currentProfile;
    if (current == null) return;

    final updated = current.copyWith(avatar: event.avatar);
    emit(ProfileUpdating(profile: updated));
    try {
      await _updateAvatar(profile: updated);
      emit(ProfileLoaded(profile: updated));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
      emit(ProfileLoaded(profile: current));
    }
  }

  FutureOr<void> _onLoggedOut(
    ProfileLogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _logoutProfile();
      emit(const ProfileLogoutSuccess());
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileLogoutFailure(message: e.toString()));
    }
  }
}
