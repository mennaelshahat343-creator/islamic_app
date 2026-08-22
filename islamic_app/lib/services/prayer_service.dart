import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/prayer_times_model.dart';

/// خدمة مواقيت الصلاة - تعتمد على Aladhan API (مصدر موثوق ومفتوح)
/// https://aladhan.com/prayer-times-api
class PrayerService {
  final Duration _timeout = const Duration(seconds: 12);

  /// جلب مواقيت الصلاة ليوم محدد بناءً على الإحداثيات وطريقة الحساب
  /// method: رقم طريقة الحساب حسب توثيق Aladhan (مثال: 4 = أم القرى، 5 = الهيئة المصرية...)
  Future<PrayerTimesModel> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    int method = 4,
  }) async {
    final timestamp = (date.millisecondsSinceEpoch / 1000).round();
    final uri = Uri.parse('${AppConstants.prayerApiBase}/timings/$timestamp').replace(
      queryParameters: {
        'latitude': '$latitude',
        'longitude': '$longitude',
        'method': '$method',
      },
    );
    final response = await http.get(uri).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('فشل تحميل مواقيت الصلاة (${response.statusCode})');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return PrayerTimesModel.fromAladhanJson(data, date);
  }

  /// قائمة طرق الحساب المتاحة (الأكثر شيوعًا للعالم العربي والإسلامي)
  static const Map<int, String> calculationMethods = {
    4: 'أم القرى - السعودية',
    5: 'الهيئة المصرية العامة للمساحة',
    3: 'رابطة العالم الإسلامي',
    2: 'الجمعية الإسلامية لأمريكا الشمالية (ISNA)',
    1: 'جامعة العلوم الإسلامية - كراتشي',
    8: 'دائرة الشؤون الدينية - الإمارات',
    16: 'دبي',
  };
}
