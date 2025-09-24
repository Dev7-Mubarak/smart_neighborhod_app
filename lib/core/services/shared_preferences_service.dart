import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/login_model.dart';
import '../constants/shared_preferences_keys.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isOnboardingCompleted =>
      _prefs?.getBool('onboarding_completed') ?? false;
  static Future<void> setOnboardingCompleted() async =>
      await _prefs?.setBool('onboarding_completed', true);

  static bool get isLoggedIn => _prefs?.getBool('is_logged_in') ?? false;
  static Future<void> setLoggedIn(bool value) async =>
      await _prefs?.setBool('is_logged_in', value);

  static Future<void> setValue(String key, dynamic value) async {
    if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else {
      throw ArgumentError("Unsupported type");
    }
  }

  static dynamic getValue(String key) => _prefs?.get(key);

  static ProfileModel? getProfile() {
    final profileString = _prefs?.getString(SharedPreferencesKeys.profile);
    if (profileString != null) {
      try {
        final profileJson = jsonDecode(profileString) as Map<String, dynamic>;
        debugPrint("Profile from local storage: $profileJson");
        return ProfileModel.fromJson(profileJson);
      } catch (e) {
        debugPrint("Error parsing profile: $e");
        removeProfile(); // Optional: clear corrupted data
      }
    }
    return null;
  }

  static Future<void> setProfile(ProfileModel profile) async {
    final profileJson = jsonEncode(profile.toJson());
    await _prefs?.setString(SharedPreferencesKeys.profile, profileJson);
    await setLoggedIn(true);
  }

  static Future<void> removeProfile() async {
    await _prefs?.remove(SharedPreferencesKeys.profile);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
