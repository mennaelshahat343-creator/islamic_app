import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../services/storage_service.dart';

/// مزوّد وضع الثيم (فاتح/داكن/تلقائي) مع الحفظ محليًا
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadSaved();
  }

  void _loadSaved() {
    final saved = StorageService.instance.getString(AppConstants.keyThemeMode);
    switch (saved) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await StorageService.instance.setString(AppConstants.keyThemeMode, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
