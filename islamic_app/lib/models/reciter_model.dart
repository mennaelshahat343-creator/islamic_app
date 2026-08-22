/// نموذج القارئ - يُستخدم لتحديد edition الصوت في AlQuran Cloud API
class ReciterModel {
  final String identifier; // مثل: ar.alafasy
  final String name;

  const ReciterModel({required this.identifier, required this.name});

  static const List<ReciterModel> reciters = [
    ReciterModel(identifier: 'ar.alafasy', name: 'مشاري راشد العفاسي'),
    ReciterModel(identifier: 'ar.abdulbasitmurattal', name: 'عبد الباسط عبد الصمد (مرتل)'),
    ReciterModel(identifier: 'ar.abdurrahmaansudais', name: 'عبد الرحمن السديس'),
    ReciterModel(identifier: 'ar.husary', name: 'محمود خليل الحصري'),
    ReciterModel(identifier: 'ar.minshawi', name: 'محمد صديق المنشاوي'),
    ReciterModel(identifier: 'ar.hudhaify', name: 'علي بن عبد الرحمن الحذيفي'),
    ReciterModel(identifier: 'ar.shaatree', name: 'أبو بكر الشاطري'),
  ];
}
