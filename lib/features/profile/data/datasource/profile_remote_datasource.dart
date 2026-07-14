import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/core/services/auth_services.dart';
import 'package:personal_fitness_tracker/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getCurrentProfile({required String userId});

  Future<void> updateUsername({required ProfileModel model});

  Future<void> updateHeight({required ProfileModel model});

  Future<void> updateWeight({required ProfileModel model});

  Future<void> updateAvatar({required ProfileModel model});

  Future<void> updateProfile({
    required ProfileModel model,
    required bool updateUsername,
    required bool updateHeight,
    required bool updateWeight,
    required bool updateAvatar,
  });

  Future<void> logoutProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDatasource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  static const _table = "profiles";

  @override
  Future<ProfileModel> getCurrentProfile({required String userId}) async {
    // TODO: implement getCurrentProfile
    try {
      final response = await supabaseClient
          .from(_table)
          .select()
          .eq('user_id', userId)
          .limit(1);
      if (response.isEmpty) throw ServerException(message: 'Profile not found');
      return ProfileModel.fromJson(response.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateAvatar({required ProfileModel model}) async {
    try {
      await supabaseClient
          .from(_table)
          .update({'avatar': model.avatar})
          .eq("user_id", model.userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateHeight({required ProfileModel model}) async {
    try {
      await supabaseClient
          .from(_table)
          .update({'height': model.height})
          .eq("user_id", model.userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateUsername({required ProfileModel model}) async {
    try {
      await supabaseClient
          .from(_table)
          .update({'username': model.username})
          .eq("user_id", model.userId);
      await supabaseClient.auth.updateUser(
        UserAttributes(data: {'username': model.username}),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateWeight({required ProfileModel model}) async {
    try {
      await supabaseClient
          .from(_table)
          .update({'weight': model.weight})
          .eq("user_id", model.userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateProfile({
    required ProfileModel model,
    required bool updateUsername,
    required bool updateHeight,
    required bool updateWeight,
    required bool updateAvatar,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (updateUsername) updates['username'] = model.username;
      if (updateHeight) updates['height'] = model.height;
      if (updateWeight) updates['weight'] = model.weight;
      if (updateAvatar) updates['avatar'] = model.avatar;

      if (updates.isNotEmpty) {
        await supabaseClient
            .from(_table)
            .update(updates)
            .eq("user_id", model.userId);
      }

      if (updateUsername) {
        await supabaseClient.auth.updateUser(
          UserAttributes(data: {'username': model.username}),
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logoutProfile() async {
    try {
      final AuthServices authService = AuthServices();
      await authService.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
