import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/usecases/get_current_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/logout_profile_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_event.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentProfileUseCase _getCurrentProfile;
  final UpdateProfileUseCase _updateProfile;
  final LogoutProfileUseCase _logoutProfile;

  ProfileBloc({
    required GetCurrentProfileUseCase getCurrentProfile,
    required UpdateProfileUseCase updateProfile,
    required LogoutProfileUseCase logoutProfile,
  }) : _getCurrentProfile = getCurrentProfile,
       _updateProfile = updateProfile,
       _logoutProfile = logoutProfile,
       super(ProfileInitial()) {
    on<ProfileFetched>(_onProfileFetched);
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
        final result = await _getCurrentProfile(
          ProfileParams(userId: event.userId),
        );
        result.fold(
          (failure) => emit(ProfileError(message: failure.message)),
          (profile) => emit(ProfileLoaded(profile: profile)),
        );
      } catch (e) {
        emit(ProfileError(message: e.toString()));
        emit(ProfileLoaded(profile: s.profile));
      }
      return;
    }

    try {
      final result = await _getCurrentProfile(
        ProfileParams(userId: event.userId),
      );
      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (profile) => emit(ProfileLoaded(profile: profile)),
      );
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
      final hasHeightChanged =
          event.height != null && (event.height! - current.height).abs() > 0.01;
      final hasWeightChanged =
          event.weight != null && (event.weight! - current.weight).abs() > 0.01;
      final hasAvatarChanged =
          event.avatar != null && event.avatar != current.avatar;

      if (hasUsernameChanged ||
          hasHeightChanged ||
          hasWeightChanged ||
          hasAvatarChanged) {
        await _updateProfile(UpdateProfileParams(profile: updated));
      }
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
      await _logoutProfile(NoParams());
      emit(const ProfileLogoutSuccess());
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileLogoutFailure(message: e.toString()));
    }
  }
}
