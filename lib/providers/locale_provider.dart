import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  LocaleProvider() {
    _loadSavedLocale();
  }
  
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code');
      if (languageCode != null) {
        _locale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }
  
  Future<void> setLocale(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;
      
      // Save to shared preferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('language_code', newLocale.languageCode);
      } catch (e) {
        print('Error saving locale: $e');
      }
      
      notifyListeners();
    }
  }
  
  Future<void> setLanguage(String languageCode) async {
    await setLocale(Locale(languageCode));
  }
  
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isArabic => _locale.languageCode == 'ar';
}
