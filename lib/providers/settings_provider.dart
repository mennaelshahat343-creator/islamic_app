import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/reciter_model.dart';
import '../services/storage_service.dart';

/// حالة إعدادات التطبيق العامة
class SettingsState {
  final double quranFontSize;
  final int calculationMethod;
  final String reciterId;
  final bool notificationsEnabled;
  final Set<String> enabledPrayerAlerts;

  const SettingsState({
    required this.quranFontSize,
    required this.calculationMethod,
    required this.reciterId,
    required this.notificationsEnabled,
    required this.enabledPrayerAlerts,
  });

  SettingsState copyWith({
    double? quranFontSize,
    int? calculationMethod,
    String? reciterId,
    bool? notificationsEnabled,
    Set<String>? enabledPrayerAlerts,
  }) {
    return SettingsState(
      quranFontSize: quranFontSize ?? this.quranFontSize,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      reciterId: reciterId ?? this.reciterId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      enabledPrayerAlerts: enabledPrayerAlerts ?? this.enabledPrayerAlerts,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final _storage = StorageService.instance;

  SettingsNotifier()
      : super(SettingsState(
          quranFontSize: AppConstants.defaultFontSize,
          calculationMethod: 4,
          reciterId: ReciterModel.reciters.first.identifier,
          notificationsEnabled: true,
          enabledPrayerAlerts: const {'الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'},
        )) {
    _load();
  }

  void _load() {
    final fontSize = _storage.getDouble(AppConstants.keyFontSize) ?? AppConstants.defaultFontSize;
    final method = _storage.getInt(AppConstants.keyCalculationMethod) ?? 4;
    final reciter = _storage.getString(AppConstants.keyReciterId) ?? ReciterModel.reciters.first.identifier;
    final notifEnabled = _storage.getBool(AppConstants.keyNotificationsEnabled) ?? true;
    state = state.copyWith(
      quranFontSize: fontSize,
      calculationMethod: method,
      reciterId: reciter,
      notificationsEnabled: notifEnabled,
    );
  }

  Future<void> setFontSize(double size) async {
    final clamped = size.clamp(AppConstants.minFontSize, AppConstants.maxFontSize);
    state = state.copyWith(quranFontSize: clamped);
    await _storage.setDouble(AppConstants.keyFontSize, clamped);
  }

  Future<void> setCalculationMethod(int method) async {
    state = state.copyWith(calculationMethod: method);
    await _storage.setInt(AppConstants.keyCalculationMethod, method);
  }

  Future<void> setReciter(String identifier) async {
    state = state.copyWith(reciterId: identifier);
    await _storage.setString(AppConstants.keyReciterId, identifier);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _storage.setBool(AppConstants.keyNotificationsEnabled, enabled);
  }

  Future<void> togglePrayerAlert(String prayerName, bool enabled) async {
    final updated = {...state.enabledPrayerAlerts};
    if (enabled) {
      updated.add(prayerName);
    } else {
      updated.remove(prayerName);
    }
    state = state.copyWith(enabledPrayerAlerts: updated);
    await _storage.setBool('${AppConstants.keyPrayerAlertPrefix}$prayerName', enabled);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
