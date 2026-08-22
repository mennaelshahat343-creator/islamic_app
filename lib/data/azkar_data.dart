import '../models/azkar_model.dart';

/// بيانات الأذكار الأساسية - مقتبسة من كتاب "حصن المسلم" للشيخ سعيد بن علي بن وهف القحطاني
/// (مرجع تراثي إسلامي متداول وموثوق، غير خاضع لحقوق نشر حديثة).
///
/// ملاحظة للمطوّر: هذه مجموعة أولية أساسية لكل فئة لتشغيل التطبيق فعليًا.
/// يوصى بإكمال القائمة الكاملة (تتجاوز 200 ذكر) من نسخة رقمية موثوقة لـ"حصن المسلم"
/// أو عبر ربط API مخصص مثل: https://www.hisnmuslim.com/api/
class AzkarData {
  AzkarData._();

  static final List<AzkarCategory> categories = [
    AzkarCategory(
      id: 'morning',
      title: 'أذكار الصباح',
      icon: 'wb_sunny',
      items: [
        const AzkarItem(
          id: 'morning_1',
          text:
              'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          repeat: 1,
          source: 'رواه مسلم',
        ),
        const AzkarItem(
          id: 'morning_2',
          text:
              'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
          repeat: 1,
          source: 'رواه الترمذي',
        ),
        const AzkarItem(
          id: 'morning_3',
          text: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي',
          repeat: 3,
          source: 'رواه أبو داود',
        ),
        const AzkarItem(
          id: 'morning_4',
          text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          repeat: 100,
          note: 'حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
          source: 'متفق عليه',
        ),
      ],
    ),
    AzkarCategory(
      id: 'evening',
      title: 'أذكار المساء',
      icon: 'nights_stay',
      items: [
        const AzkarItem(
          id: 'evening_1',
          text:
              'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
          repeat: 1,
          source: 'رواه مسلم',
        ),
        const AzkarItem(
          id: 'evening_2',
          text: 'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلاَئِكَتَكَ، وَجَمِيعَ خَلْقِكَ',
          repeat: 4,
          source: 'رواه أبو داود',
        ),
        const AzkarItem(
          id: 'evening_3',
          text: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          repeat: 3,
          source: 'رواه مسلم',
        ),
      ],
    ),
    AzkarCategory(
      id: 'after_prayer',
      title: 'أذكار بعد الصلاة',
      icon: 'mosque',
      items: [
        const AzkarItem(id: 'after_1', text: 'أَسْتَغْفِرُ اللَّهَ', repeat: 3, source: 'رواه مسلم'),
        const AzkarItem(
          id: 'after_2',
          text: 'اللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ',
          repeat: 1,
          source: 'رواه مسلم',
        ),
        const AzkarItem(id: 'after_3', text: 'سُبْحَانَ اللَّهِ', repeat: 33, source: 'متفق عليه'),
        const AzkarItem(id: 'after_4', text: 'الْحَمْدُ لِلَّهِ', repeat: 33, source: 'متفق عليه'),
        const AzkarItem(id: 'after_5', text: 'اللَّهُ أَكْبَرُ', repeat: 33, source: 'متفق عليه'),
      ],
    ),
    AzkarCategory(
      id: 'sleep',
      title: 'أذكار النوم',
      icon: 'bedtime',
      items: [
        const AzkarItem(
          id: 'sleep_1',
          text: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          repeat: 1,
          source: 'رواه البخاري',
        ),
        const AzkarItem(
          id: 'sleep_2',
          text: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
          repeat: 3,
          source: 'رواه أبو داود والترمذي',
        ),
      ],
    ),
    AzkarCategory(
      id: 'wake_up',
      title: 'أذكار الاستيقاظ',
      icon: 'alarm',
      items: [
        const AzkarItem(
          id: 'wake_1',
          text: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          repeat: 1,
          source: 'رواه البخاري',
        ),
      ],
    ),
    AzkarCategory(
      id: 'travel',
      title: 'أذكار السفر',
      icon: 'flight_takeoff',
      items: [
        const AzkarItem(
          id: 'travel_1',
          text:
              'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
          repeat: 1,
          source: 'رواه مسلم',
        ),
      ],
    ),
    AzkarCategory(
      id: 'misc',
      title: 'أدعية متنوعة',
      icon: 'volunteer_activism',
      items: [
        const AzkarItem(
          id: 'misc_1',
          text: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
          repeat: 1,
          source: 'سورة البقرة - 201',
        ),
        const AzkarItem(
          id: 'misc_2',
          text: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
          repeat: 1,
          source: 'سورة طه - 25-26',
        ),
      ],
    ),
  ];
}
