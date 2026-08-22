/// النصوص الثابتة في التطبيق (عربي أساسي، جاهز لإضافة الإنجليزية عبر l10n)
class AppStrings {
  AppStrings._();

  static const String appName = 'نور';
  static const String appTagline = 'رفيقك في العبادة اليومية';

  // Navigation
  static const String navHome = 'الرئيسية';
  static const String navQuran = 'القرآن';
  static const String navPrayer = 'الصلاة';
  static const String navAzkar = 'الأذكار';
  static const String navMore = 'المزيد';

  // Home
  static const String greetingMorning = 'صباح الخير';
  static const String greetingAfternoon = 'مساء الخير';
  static const String greetingEvening = 'مساء النور';
  static const String nextPrayer = 'الصلاة القادمة';
  static const String remainingTime = 'الوقت المتبقي';
  static const String quickQuran = 'القرآن الكريم';
  static const String quickAzkar = 'الأذكار';
  static const String quickQibla = 'القبلة';
  static const String quickPrayerTimes = 'مواقيت الصلاة';
  static const String quickHadith = 'الأحاديث';
  static const String quickTasbeeh = 'التسبيح';

  // Quran
  static const String surahList = 'قائمة السور';
  static const String searchSurah = 'ابحث عن سورة أو آية';
  static const String makkiyah = 'مكية';
  static const String madaniyah = 'مدنية';
  static const String verses = 'آية';
  static const String continueReading = 'متابعة القراءة';
  static const String addToFavorites = 'إضافة إلى المفضلة';
  static const String removeFromFavorites = 'إزالة من المفضلة';
  static const String shareVerse = 'مشاركة الآية';
  static const String copyVerse = 'نسخ الآية';
  static const String fontSize = 'حجم الخط';
  static const String selectReciter = 'اختر القارئ';

  // Prayer
  static const String fajr = 'الفجر';
  static const String sunrise = 'الشروق';
  static const String dhuhr = 'الظهر';
  static const String asr = 'العصر';
  static const String maghrib = 'المغرب';
  static const String isha = 'العشاء';
  static const String calculationMethod = 'طريقة الحساب';
  static const String enableLocation = 'تفعيل الموقع';
  static const String locationPermissionMsg =
      'نحتاج إلى إذن الوصول لموقعك لحساب مواقيت الصلاة واتجاه القبلة بدقة لمنطقتك.';

  // Qibla
  static const String qiblaDirection = 'اتجاه القبلة';
  static const String qiblaCalibrate = 'قم بتحريك جهازك على شكل ∞ لمعايرة البوصلة';
  static const String qiblaNoSensor = 'جهازك لا يحتوي على حساس بوصلة مدمج، لا يمكن عرض اتجاه القبلة تلقائيًا.';
  static const String distanceToMakkah = 'المسافة إلى مكة المكرمة';

  // Azkar
  static const String azkarMorning = 'أذكار الصباح';
  static const String azkarEvening = 'أذكار المساء';
  static const String azkarAfterPrayer = 'أذكار بعد الصلاة';
  static const String azkarSleep = 'أذكار النوم';
  static const String azkarWakeUp = 'أذكار الاستيقاظ';
  static const String azkarTravel = 'أذكار السفر';
  static const String azkarMisc = 'أدعية متنوعة';
  static const String hisnAlMuslim = 'حصن المسلم';

  // Tasbeeh
  static const String tasbeehTitle = 'التسبيح الإلكتروني';
  static const String totalCount = 'الإجمالي';
  static const String resetCounter = 'إعادة تعيين';

  // Hadith
  static const String hadithOfDay = 'حديث اليوم';
  static const String narrator = 'الراوي';
  static const String source = 'المصدر';
  static const String grade = 'الدرجة';

  // Common
  static const String settings = 'الإعدادات';
  static const String favorites = 'المفضلة';
  static const String search = 'بحث';
  static const String retry = 'إعادة المحاولة';
  static const String noInternet = 'لا يوجد اتصال بالإنترنت';
  static const String noInternetMsg = 'هذا المحتوى يحتاج إلى اتصال بالإنترنت. تحقق من اتصالك وحاول مجددًا.';
  static const String errorGeneric = 'حدث خطأ غير متوقع';
  static const String loading = 'جارِ التحميل...';
  static const String empty = 'لا توجد عناصر بعد';
  static const String darkMode = 'الوضع الليلي';
  static const String about = 'حول التطبيق';
  static const String privacy = 'الخصوصية';
}
