/// نموذج بيانات السورة
class SurahModel {
  final int number;
  final String name; // الاسم بالعربية
  final String englishName;
  final String englishNameTranslation;
  final String revelationType; // Meccan / Medinan
  final int numberOfAyahs;

  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
  });

  bool get isMakki => revelationType.toLowerCase() == 'meccan';

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String? ?? '',
      englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
      revelationType: json['revelationType'] as String? ?? 'Meccan',
      numberOfAyahs: json['numberOfAyahs'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'revelationType': revelationType,
        'numberOfAyahs': numberOfAyahs,
      };

  @override
  bool operator ==(Object other) => other is SurahModel && other.number == number;

  @override
  int get hashCode => number.hashCode;
}

/// نموذج بيانات الآية
class AyahModel {
  final int number; // الرقم المطلق في القرآن
  final int numberInSurah;
  final String text;
  final int surahNumber;
  final String surahName;
  final int? juz;
  final int? page;

  const AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.text,
    required this.surahNumber,
    required this.surahName,
    this.juz,
    this.page,
  });

  /// معرف فريد يُستخدم في المفضلة وحفظ الموضع (سورة:آية)
  String get id => '$surahNumber:$numberInSurah';

  factory AyahModel.fromJson(Map<String, dynamic> json, {int? surahNumberOverride, String? surahNameOverride}) {
    final surahJson = json['surah'] as Map<String, dynamic>?;
    return AyahModel(
      number: json['number'] as int? ?? 0,
      numberInSurah: json['numberInSurah'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      surahNumber: surahNumberOverride ?? surahJson?['number'] as int? ?? 0,
      surahName: surahNameOverride ?? surahJson?['name'] as String? ?? '',
      juz: json['juz'] as int?,
      page: json['page'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'numberInSurah': numberInSurah,
        'text': text,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'juz': juz,
        'page': page,
      };

  @override
  bool operator ==(Object other) =>
      other is AyahModel && other.surahNumber == surahNumber && other.numberInSurah == numberInSurah;

  @override
  int get hashCode => Object.hash(surahNumber, numberInSurah);
}
