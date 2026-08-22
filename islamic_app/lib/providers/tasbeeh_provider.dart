import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// حالة التسبيح الحالية: الذكر المختار وعدده
class TasbeehState {
  final String dhikrId;
  final String dhikrText;
  final int count;

  const TasbeehState({required this.dhikrId, required this.dhikrText, required this.count});

  TasbeehState copyWith({String? dhikrId, String? dhikrText, int? count}) {
    return TasbeehState(
      dhikrId: dhikrId ?? this.dhikrId,
      dhikrText: dhikrText ?? this.dhikrText,
      count: count ?? this.count,
    );
  }
}

class TasbeehNotifier extends StateNotifier<TasbeehState> {
  final _storage = StorageService.instance;

  TasbeehNotifier() : super(const TasbeehState(dhikrId: 'subhanallah', dhikrText: 'سبحان الله', count: 0)) {
    state = state.copyWith(count: _storage.getTasbeehCount('subhanallah'));
  }

  static const List<Map<String, String>> presetAdhkar = [
    {'id': 'subhanallah', 'text': 'سبحان الله'},
    {'id': 'alhamdulillah', 'text': 'الحمد لله'},
    {'id': 'allahuakbar', 'text': 'الله أكبر'},
    {'id': 'la_ilaha_illallah', 'text': 'لا إله إلا الله'},
    {'id': 'astaghfirullah', 'text': 'أستغفر الله'},
  ];

  void selectDhikr(String id, String text) {
    state = TasbeehState(dhikrId: id, dhikrText: text, count: _storage.getTasbeehCount(id));
  }

  Future<void> increment() async {
    final newCount = state.count + 1;
    state = state.copyWith(count: newCount);
    await _storage.setTasbeehCount(state.dhikrId, newCount);
  }

  Future<void> reset() async {
    state = state.copyWith(count: 0);
    await _storage.setTasbeehCount(state.dhikrId, 0);
  }

  int get totalAllTime => _storage.getTotalTasbeeh();
}

final tasbeehProvider = StateNotifierProvider<TasbeehNotifier, TasbeehState>((ref) {
  return TasbeehNotifier();
});
