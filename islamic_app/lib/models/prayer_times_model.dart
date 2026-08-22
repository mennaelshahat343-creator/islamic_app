/// نموذج مواقيت الصلاة ليوم واحد
class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String hijriDate;
  final String gregorianDate;

  const PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.hijriDate,
    required this.gregorianDate,
  });

  /// قائمة مرتبة بأسماء الصلوات وأوقاتها لعرضها في الواجهة
  List<PrayerEntry> get orderedEntries => [
        PrayerEntry('الفجر', fajr),
        PrayerEntry('الشروق', sunrise),
        PrayerEntry('الظهر', dhuhr),
        PrayerEntry('العصر', asr),
        PrayerEntry('المغرب', maghrib),
        PrayerEntry('العشاء', isha),
      ];

  /// إيجاد الصلاة القادمة بالنسبة للوقت الحالي (يستثني الشروق من كونه صلاة)
  PrayerEntry? nextPrayer(DateTime now) {
    final prayerOnly = [
      PrayerEntry('الفجر', fajr),
      PrayerEntry('الظهر', dhuhr),
      PrayerEntry('العصر', asr),
      PrayerEntry('المغرب', maghrib),
      PrayerEntry('العشاء', isha),
    ];
    for (final p in prayerOnly) {
      if (p.time.isAfter(now)) return p;
    }
    return null; // بعد العشاء: القادمة فجر الغد (يُحسب خارجيًا)
  }

  factory PrayerTimesModel.fromAladhanJson(Map<String, dynamic> json, DateTime referenceDate) {
    final timings = json['timings'] as Map<String, dynamic>;
    final dateInfo = json['date'] as Map<String, dynamic>;
    final hijri = dateInfo['hijri'] as Map<String, dynamic>;
    final gregorian = dateInfo['gregorian'] as Map<String, dynamic>;

    DateTime parseTime(String raw) {
      final cleaned = raw.split(' ').first; // يزيل أي منطقة زمنية ملحقة مثل (EET)
      final parts = cleaned.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(referenceDate.year, referenceDate.month, referenceDate.day, hour, minute);
    }

    final hijriMonth = (hijri['month'] as Map<String, dynamic>)['ar'] as String? ?? '';
    final hijriStr = '${hijri['day']} $hijriMonth ${hijri['year']} هـ';
    final gregorianStr = '${gregorian['day']}/${gregorian['month']['number']}/${gregorian['year']}';

    return PrayerTimesModel(
      fajr: parseTime(timings['Fajr']),
      sunrise: parseTime(timings['Sunrise']),
      dhuhr: parseTime(timings['Dhuhr']),
      asr: parseTime(timings['Asr']),
      maghrib: parseTime(timings['Maghrib']),
      isha: parseTime(timings['Isha']),
      hijriDate: hijriStr,
      gregorianDate: gregorianStr,
    );
  }
}

class PrayerEntry {
  final String name;
  final DateTime time;
  const PrayerEntry(this.name, this.time);
}
