import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project_bank_sampah/model/account.dart';
import 'package:mini_project_bank_sampah/model/user_profile.dart';
import 'package:mini_project_bank_sampah/service/auth_service.dart';
import 'package:supabase/supabase.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthViewmodel._internal();
  static final _singleton = AuthViewmodel._internal();
  factory AuthViewmodel() => _singleton;

  final AuthService _authService = AuthService();

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  void logout() async {
    await _authService.logout();
    _userProfile = null;
    notifyListeners();
  }

  void loadUserProfile(String userid,
      {Function(UserProfile?)? callback}) async {
    _userProfile = await _authService.getProfile(userid);
    callback?.call(_userProfile);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
      {required String username, required String password}) async {
    _isLoading = true;
    notifyListeners();
    // using auth service to login
    try {
      final account = await _authService.signIn(username, password);
      loadUserProfile(account.user?.id ?? '');
    } catch (e) {
      print(e);
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(
      {required String username,
      required String password,
      required String name}) async {
    _isLoading = true;
    notifyListeners();
    // using auth service to register new account
    try {
      await _authService.signUp(username, password, name);
    } catch (e) {
      print(e);
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future updateProfilePicture(String path) async {
    _isLoading = true;
    notifyListeners();
    try {
      final url = await _authService.updateProfilePicture(path, userProfile);
      _userProfile?.photoProfile = url;
      await _authService.updateProfile(_userProfile!);
    } catch (e) {
      print("authvm: $e");
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future saveProfile(
      {required String name,
      required String phone,
      required String address}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userProfile?.username = name;
      _userProfile?.address = address;
      _userProfile?.phone = phone;

      await _authService.updateProfile(_userProfile!);
    } catch (e) {
      print("authvm: $e");
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }
}
