import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/surah_model.dart';
import '../services/quran_service.dart';
import '../services/storage_service.dart';

final quranServiceProvider = Provider((ref) => QuranService());

/// قائمة السور (تُحمّل مرة واحدة وتُخزَّن مؤقتًا في الذاكرة عبر Riverpod cache)
final surahListProvider = FutureProvider<List<SurahModel>>((ref) async {
  final service = ref.watch(quranServiceProvider);
  return service.getSurahList();
});

/// آيات سورة محددة
final surahAyahsProvider = FutureProvider.family<List<AyahModel>, int>((ref, surahNumber) async {
  final service = ref.watch(quranServiceProvider);
  return service.getSurahAyahs(surahNumber);
});

/// آخر موضع قراءة تم حفظه محليًا (Offline)
final lastReadPositionProvider = StateProvider<Map<String, int>?>((ref) {
  return StorageService.instance.getLastPosition();
});
