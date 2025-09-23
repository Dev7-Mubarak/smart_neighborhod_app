import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/login_model.dart';
import '../constants/shared_preferences_keys.dart';

class SharedPreferencesService {
  static late SharedPreferences _pref;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> setValue(String key, dynamic value) async {
    if (value is bool) {
      await _pref.setBool(key, value);
    } else if (value is int) {
      await _pref.setInt(key, value);
    } else if (value is double) {
      await _pref.setDouble(key, value);
    } else if (value is String) {
      await _pref.setString(key, value);
    } else {
      throw ArgumentError("Unsupported type");
    }
  }

  static dynamic getValue(String key) => _pref.get(key);

  static ProfileModel? getProfile() {
    final profileString = _pref.getString(SharedPreferencesKeys.profile);
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
    await _pref.setString(SharedPreferencesKeys.profile, profileJson);
  }

  static Future<void> removeProfile() async {
    await _pref.remove(SharedPreferencesKeys.profile);
  }

  static Future<void> clear() async {
    await _pref.clear();
  }
}
