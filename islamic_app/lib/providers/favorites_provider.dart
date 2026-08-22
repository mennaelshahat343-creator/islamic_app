import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

const String favTypeVerse = 'verse';
const String favTypeHadith = 'hadith';
const String favTypeAzkar = 'azkar';

/// مزوّد المفضلة الموحّد للآيات والأحاديث والأذكار
class FavoritesNotifier extends StateNotifier<int> {
  // نستخدم عداد بسيط (tick) لإجبار الواجهة على إعادة البناء عند أي تغيير
  FavoritesNotifier() : super(0);

  final _storage = StorageService.instance;

  Future<void> toggle(String type, Map<String, dynamic> data) async {
    final id = data['id'].toString();
    if (_storage.isFavorite(type, id)) {
      await _storage.removeFavorite(type, id);
    } else {
      await _storage.addFavorite(type, data);
    }
    state++;
  }

  bool isFavorite(String type, String id) => _storage.isFavorite(type, id);

  List<Map> byType(String type) => _storage.favoritesByType(type);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, int>((ref) {
  return FavoritesNotifier();
});
