/// نموذج الحديث الشريف
class HadithModel {
  final String id;
  final String text;
  final String narrator; // الراوي
  final String source; // المصدر (كالبخاري، مسلم...)
  final String? grade; // درجة الصحة إن توفرت

  const HadithModel({
    required this.id,
    required this.text,
    required this.narrator,
    required this.source,
    this.grade,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) => HadithModel(
        id: json['id'] as String,
        text: json['text'] as String,
        narrator: json['narrator'] as String,
        source: json['source'] as String,
        grade: json['grade'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'narrator': narrator,
        'source': source,
        'grade': grade,
      };
}
