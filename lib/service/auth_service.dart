import 'dart:io';

import 'package:mini_project_bank_sampah/model/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  GoTrueClient get auth => client.auth;
  SupabaseClient get client => Supabase.instance.client;
  SupabaseStorageClient get storage => client.storage;
  Future<AuthResponse> signUp(
      String email, String password, String name) async {
    try {
      final response = await auth.signUp(password: password, email: email);
      await client.from('user_profile').insert([
        {
          'userid': response.user?.id,
          'username': name,
        }
      ]);

      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response =
          await auth.signInWithPassword(email: email, password: password);
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> updateProfile(UserProfile userProfile) async {
    try {
      final response = await client
          .from('user_profile')
          .update(userProfile.toJson())
          .eq('userid', userProfile.userid);
      final data = response as List;
      return data.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserProfile> getProfile(String userId) async {
    try {
      final response = await client
          .from('user_profile')
          .select()
          .eq('userid', userId)
          .single();
      final data = response as Map<String, dynamic>;
      print(data);
      return UserProfile.fromJson(data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> logout() {
    return auth.signOut();
  }

  Future<String> updateProfilePicture(
      String imagePath, UserProfile? profile) async {
    try {
      final storageClient = storage.from("photo.profile");
      final filename = imagePath.split("/").last;
      String url = await storageClient.upload(filename, File(imagePath));
      if (!url.startsWith("http")) {
        url =
            "https://tfkfnpwounbbwljvzusl.supabase.co/storage/v1/object/public/$url";
      }
      final newProfile = profile?.copyWith(photoProfile: url);
      await client
          .from('user_profile')
          .update(newProfile?.toJson() ?? {})
          .eq('userid', auth.currentUser?.id);
      return url;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
