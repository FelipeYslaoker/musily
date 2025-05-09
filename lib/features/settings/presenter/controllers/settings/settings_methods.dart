import 'package:flutter/material.dart';
import 'package:musily/features/settings/domain/enums/accent_color_preference.dart';
import 'package:musily/features/settings/domain/enums/close_preference.dart';

class SettingsMethods {
  final Future<void> Function(
    String? locale,
  ) changeLanguage;
  final void Function(ThemeMode? mode) changeTheme;
  final Future<void> Function() loadLanguage;
  final Future<void> Function() loadThemeMode;
  final void Function() setBrightness;
  final void Function() loadClosePreference;
  final void Function(ClosePreference preference) setClosePreference;
  final void Function(
    AccentColorPreference preference,
  ) setAccentColorPreference;
  final void Function() loadAccentColorPreference;

  SettingsMethods({
    required this.changeLanguage,
    required this.changeTheme,
    required this.loadLanguage,
    required this.loadThemeMode,
    required this.setBrightness,
    required this.loadClosePreference,
    required this.setClosePreference,
    required this.setAccentColorPreference,
    required this.loadAccentColorPreference,
  });
}
