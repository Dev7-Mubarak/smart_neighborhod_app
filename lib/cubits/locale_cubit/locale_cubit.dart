import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(locale: const Locale('ar'))) {
    _loadSavedLocale();
  }

  void changeLocale(Locale locale) async {
    emit(LocaleState(locale: locale));
    await _saveLocale(locale);
  }

  void toggleLocale() {
    if (state.locale.languageCode == 'ar') {
      changeLocale(const Locale('en'));
    } else {
      changeLocale(const Locale('ar'));
    }
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('locale') ?? 'ar';
    emit(LocaleState(locale: Locale(languageCode)));
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}