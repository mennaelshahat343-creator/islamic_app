import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

/// خدمة التخزين المحلي الموحّدة (Offline-first)
/// تستخدم Hive للبيانات المركّبة (مفضلة، تقدم القراءة) و
/// SharedPreferences للإعدادات البسيطة (Key-Value).
class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  late Box _settingsBox;
  late Box _favoritesBox;
  late Box _quranProgressBox;
  late Box _tasbeehBox;
  late SharedPreferences _prefs;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(AppConstants.boxSettings);
    _favoritesBox = await Hive.openBox(AppConstants.boxFavorites);
    _quranProgressBox = await Hive.openBox(AppConstants.boxQuranProgress);
    _tasbeehBox = await Hive.openBox(AppConstants.boxTasbeeh);
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ---------------- Settings (Simple KV) ----------------
  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);
  Future<void> setDouble(String key, double value) => _prefs.setDouble(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  // ---------------- Favorites (Box<Map>) ----------------
  Box get favoritesBox => _favoritesBox;

  Future<void> addFavorite(String type, Map<String, dynamic> data) async {
    await _favoritesBox.put('$type::${data['id']}', {'type': type, ...data});
  }

  Future<void> removeFavorite(String type, String id) async {
    await _favoritesBox.delete('$type::$id');
  }

  bool isFavorite(String type, String id) => _favoritesBox.containsKey('$type::$id');

  List<Map> favoritesByType(String type) {
    return _favoritesBox.values
        .whereType<Map>()
        .where((e) => e['type'] == type)
        .toList();
  }

  // ---------------- Quran Progress ----------------
  Future<void> saveLastPosition(int surah, int ayah) async {
    await _quranProgressBox.put('last_surah', surah);
    await _quranProgressBox.put('last_ayah', ayah);
  }

  Map<String, int>? getLastPosition() {
    final s = _quranProgressBox.get('last_surah');
    final a = _quranProgressBox.get('last_ayah');
    if (s == null || a == null) return null;
    return {'surah': s as int, 'ayah': a as int};
  }

  // ---------------- Tasbeeh ----------------
  Future<void> setTasbeehCount(String dhikrId, int count) async {
    await _tasbeehBox.put(dhikrId, count);
  }

  int getTasbeehCount(String dhikrId) => (_tasbeehBox.get(dhikrId) as int?) ?? 0;

  int getTotalTasbeeh() {
    return _tasbeehBox.values.whereType<int>().fold(0, (a, b) => a + b);
  }
}
