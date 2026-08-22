/// نموذج فئة الأذكار (صباح، مساء، نوم...)
class AzkarCategory {
  final String id;
  final String title;
  final String icon; // اسم أيقونة Material
  final List<AzkarItem> items;

  const AzkarCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.items,
  });
}

/// نموذج ذكر واحد ضمن فئة، مع عدد التكرار المطلوب
class AzkarItem {
  final String id;
  final String text;
  final int repeat;
  final String? note; // فضل الذكر أو ملاحظة إضافية
  final String? source;

  const AzkarItem({
    required this.id,
    required this.text,
    required this.repeat,
    this.note,
    this.source,
  });
}
