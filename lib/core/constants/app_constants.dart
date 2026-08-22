/// ثوابت التطبيق العامة: عناوين الـ APIs، مفاتيح التخزين المحلي، إعدادات افتراضية
class AppConstants {
  AppConstants._();

  // =====================================================================
  // APIs (مصادر بيانات موثوقة - مجانية ومفتوحة، لا تحتاج API Key)
  // =====================================================================

  /// AlQuran Cloud API — نصوص القرآن، الترجمات، التلاوات الصوتية
  /// التوثيق: https://alquran.cloud/api
  static const String quranApiBase = 'https://api.alquran.cloud/v1';

  /// Aladhan API — مواقيت الصلاة حسب الموقع الجغرافي وطريقة الحساب
  /// التوثيق: https://aladhan.com/prayer-times-api
  static const String prayerApiBase = 'https://api.aladhan.com/v1';

  /// Al-Quran Cloud CDN لملفات الصوت (يُستخدم مع رقم القارئ / edition)
  static const String quranAudioCdnBase = 'https://cdn.islamic.network/quran/audio';

  // ملاحظة هامة لمصدر الحديث الشريف:
  // لا تتوفر حاليًا API عامة مجانية موثوقة بنسبة 100% للحديث الشريف بدون
  // اشتراك (مثل HadeethEnc أو Sunnah.com API التي تتطلب API Key مجاني بالتسجيل).
  // تم إدراج مجموعة أحاديث أساسية موثقة المصدر في lib/data/hadith_data.dart
  // ويوصى بربط Sunnah.com API (يتطلب تسجيل مجاني للحصول على مفتاح):
  // https://sunnah.api-docs.io/
  static const String hadithApiBase = 'https://api.sunnah.com/v1';
  static const String hadithApiKeyPlaceholder = 'YOUR_SUNNAH_API_KEY';

  // =====================================================================
  // Hive Boxes / SharedPreferences Keys
  // =====================================================================
  static const String boxSettings = 'settings_box';
  static const String boxFavorites = 'favorites_box';
  static const String boxQuranProgress = 'quran_progress_box';
  static const String boxTasbeeh = 'tasbeeh_box';

  static const String keyThemeMode = 'theme_mode';
  static const String keyFontSize = 'font_size';
  static const String keyQuranFont = 'quran_font';
  static const String keyLocale = 'locale';
  static const String keyCalculationMethod = 'calculation_method';
  static const String keyLastLatitude = 'last_latitude';
  static const String keyLastLongitude = 'last_longitude';
  static const String keyLastCity = 'last_city';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyAdhanSoundEnabled = 'adhan_sound_enabled';
  static const String keyPrayerAlertPrefix = 'prayer_alert_'; // + اسم الصلاة
  static const String keyLastSurah = 'last_surah';
  static const String keyLastAyah = 'last_ayah';
  static const String keyReciterId = 'reciter_id';
  static const String keyOnboardingDone = 'onboarding_done';

  // =====================================================================
  // إعدادات افتراضية
  // =====================================================================
  static const double defaultFontSize = 22.0;
  static const double minFontSize = 16.0;
  static const double maxFontSize = 34.0;

  /// إحداثيات الكعبة المشرفة - تُستخدم لحساب اتجاه القبلة والمسافة
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  static const Duration splashDuration = Duration(milliseconds: 2200);
}
