import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/surah_model.dart';

/// خدمة القرآن الكريم - تعتمد على AlQuran Cloud API (مصدر موثوق ومفتوح)
/// https://alquran.cloud/api
class QuranService {
  final Duration _timeout = const Duration(seconds: 12);

  /// جلب قائمة السور (114 سورة) مع بياناتها الأساسية
  Future<List<SurahModel>> getSurahList() async {
    final uri = Uri.parse('${AppConstants.quranApiBase}/surah');
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('فشل تحميل قائمة السور (${response.statusCode})');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final data = body['data'] as List;
    return data.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// جلب نص سورة كاملة (رواية حفص عن عاصم - النص العثماني)
  Future<List<AyahModel>> getSurahAyahs(int surahNumber) async {
    final uri = Uri.parse('${AppConstants.quranApiBase}/surah/$surahNumber/quran-uthmani');
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('فشل تحميل آيات السورة (${response.statusCode})');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final surahName = data['name'] as String;
    final ayahsJson = data['ayahs'] as List;
    return ayahsJson
        .map((e) => AyahModel.fromJson(
              e as Map<String, dynamic>,
              surahNumberOverride: surahNumber,
              surahNameOverride: surahName,
            ))
        .toList();
  }

  /// البحث في القرآن الكريم عن كلمة أو عبارة
  Future<List<AyahModel>> searchQuran(String query) async {
    if (query.trim().isEmpty) return [];
    final uri = Uri.parse('${AppConstants.quranApiBase}/search/${Uri.encodeComponent(query)}/all/ar');
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != 200) return [];
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>?;
    final matches = data?['matches'] as List? ?? [];
    return matches.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// رابط تشغيل تلاوة سورة كاملة لقارئ محدد (mp3)
  /// يُستخدم عبر CDN الخاص بـ islamic.network (audio-surah endpoint)
  /// مثال: https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3
  String surahAudioUrl(String reciterIdentifier, int surahNumber) {
    return 'https://cdn.islamic.network/quran/audio-surah/128/$reciterIdentifier/$surahNumber.mp3';
  }
}
