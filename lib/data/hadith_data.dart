import '../models/hadith_model.dart';

/// بيانات أحاديث نبوية أساسية - جميعها موثقة المصدر (البخاري ومسلم).
///
/// ملاحظة للمطوّر: هذه مجموعة أولية لتشغيل التطبيق فعليًا. للحصول على
/// قاعدة بيانات أوسع وموثوقة، يوصى بربط:
/// - Sunnah.com API (يتطلب تسجيل مجاني للحصول على مفتاح): https://sunnah.api-docs.io
/// - أو HadeethEnc API: https://hadeethenc.com/en/api/list
/// لا تقم أبدًا بتوليد أحاديث جديدة عبر الذكاء الاصطناعي أو نسبة نصوص غير موثقة لمصادر دينية.
class HadithData {
  HadithData._();

  static final List<HadithModel> hadiths = [
    const HadithModel(
      id: 'h1',
      text: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
      narrator: 'عمر بن الخطاب رضي الله عنه',
      source: 'رواه البخاري ومسلم',
    ),
    const HadithModel(
      id: 'h2',
      text: 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
      narrator: 'أبو هريرة رضي الله عنه',
      source: 'رواه البخاري ومسلم',
    ),
    const HadithModel(
      id: 'h3',
      text: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ',
      narrator: 'عبد الله بن عمرو رضي الله عنهما',
      source: 'رواه البخاري ومسلم',
    ),
    const HadithModel(
      id: 'h4',
      text: 'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
      narrator: 'أنس بن مالك رضي الله عنه',
      source: 'رواه البخاري ومسلم',
    ),
    const HadithModel(
      id: 'h5',
      text: 'الطُّهُورُ شَطْرُ الإِيمَانِ، وَالْحَمْدُ لِلَّهِ تَمْلأُ الْمِيزَانَ',
      narrator: 'أبو مالك الأشعري رضي الله عنه',
      source: 'رواه مسلم',
      grade: 'صحيح',
    ),
    const HadithModel(
      id: 'h6',
      text: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ',
      narrator: 'أبو هريرة رضي الله عنه',
      source: 'رواه مسلم',
      grade: 'صحيح',
    ),
    const HadithModel(
      id: 'h7',
      text: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
      narrator: 'عثمان بن عفان رضي الله عنه',
      source: 'رواه البخاري',
      grade: 'صحيح',
    ),
  ];

  /// حديث اليوم - يتغير بناءً على يوم السنة لضمان تنوع يومي بدون إنترنت
  static HadithModel hadithOfDay() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return hadiths[dayOfYear % hadiths.length];
  }
}
