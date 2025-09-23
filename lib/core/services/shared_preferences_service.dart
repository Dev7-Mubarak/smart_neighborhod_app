import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/login_model.dart';
import '../constants/shared_preferences_keys.dart';

class SharedPreferencesService {
  static late SharedPreferences _pref;

  //! Here The Initialize of cache .
  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> setBool(String key, bool value) async {
    await _pref.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async => await _pref.getBool(key);

  static Future<ProfileModel?> getProfile() async {
    final profileString = await _pref.getString(SharedPreferencesKeys.profile);
    if (profileString != null) {
      final profileJson = jsonDecode(profileString) as Map<String, dynamic>;
      debugPrint("the profile from local storage is $profileJson");
      return ProfileModel.fromJson(profileJson);
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
}
