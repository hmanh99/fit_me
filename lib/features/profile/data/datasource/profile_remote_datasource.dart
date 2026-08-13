import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/services/auth_services.dart';
import 'package:fit_me/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getCurrentProfile({required String userId});

  Future<void> updateProfile({required ProfileModel model});

  Future<void> logoutProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDatasource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  static const _profileTable = "profiles";

  @override
  Future<ProfileModel> getCurrentProfile({required String userId}) async {
    // TODO: implement getCurrentProfile
    try {
      final response = await supabaseClient
          .from(_profileTable)
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
  Future<void> updateProfile({required ProfileModel model}) async {
    try {
      final updates = <String, dynamic>{};
      updates['username'] = model.username;
      updates['height'] = model.height;
      updates['weight'] = model.weight;
      updates['avatar'] = model.avatar;

      if (updates.isNotEmpty) {
        await supabaseClient
            .from(_profileTable)
            .update(updates)
            .eq("user_id", model.userId);
      }

      if (model.username.isNotEmpty) {
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
