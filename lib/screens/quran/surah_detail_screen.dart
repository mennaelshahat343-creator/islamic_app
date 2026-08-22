import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../models/reciter_model.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/quran_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/quran_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/app_error_widget.dart';
import 'quran_player_widget.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;
  final int? scrollToAyah;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
    this.scrollToAyah,
  });

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  bool _showPlayer = false;

  void _openReciterPicker() {
    final settings = ref.read(settingsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: ReciterModel.reciters.map((r) {
            return RadioListTile<String>(
              value: r.identifier,
              groupValue: settings.reciterId,
              title: Text(r.name, textAlign: TextAlign.right),
              onChanged: (v) {
                ref.read(settingsProvider.notifier).setReciter(v!);
                Navigator.pop(context);
                setState(() => _showPlayer = true);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _openFontSizeSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Consumer(builder: (context, ref, __) {
        final settings = ref.watch(settingsProvider);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('حجم الخط'),
              Slider(
                value: settings.quranFontSize,
                min: 16,
                max: 34,
                divisions: 18,
                label: settings.quranFontSize.toStringAsFixed(0),
                activeColor: AppColors.primary,
                onChanged: (v) => ref.read(settingsProvider.notifier).setFontSize(v),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ayahsAsync = ref.watch(surahAyahsProvider(widget.surahNumber));
    final settings = ref.watch(settingsProvider);
    ref.watch(favoritesProvider); // لإعادة البناء عند تغيير المفضلة

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName.isEmpty ? 'السورة' : widget.surahName),
        actions: [
          IconButton(icon: const Icon(Icons.text_fields_rounded), onPressed: _openFontSizeSheet),
          IconButton(icon: const Icon(Icons.headphones_rounded), onPressed: _openReciterPicker),
        ],
      ),
      body: ayahsAsync.when(
        loading: () => const AppLoadingList(itemCount: 8, itemHeight: 60),
        error: (e, st) => AppErrorState(onRetry: () => ref.invalidate(surahAyahsProvider(widget.surahNumber))),
        data: (ayahs) {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: ayahs.length,
            itemBuilder: (context, index) {
              final ayah = ayahs[index];
              final isFav = ref.read(favoritesProvider.notifier).isFavorite(favTypeVerse, ayah.id);
              return GestureDetector(
                onLongPress: () async {
                  await StorageService.instance.saveLastPosition(ayah.surahNumber, ayah.numberInSurah);
                  ref.read(lastReadPositionProvider.notifier).state =
                      {'surah': ayah.surahNumber, 'ayah': ayah.numberInSurah};
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ موضع القراءة')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${ayah.text} ﴿${ayah.numberInSurah}﴾',
                        textAlign: TextAlign.right,
                        style: AppTheme.quranTextStyle(
                          fontSize: settings.quranFontSize,
                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFav ? AppColors.error : null,
                              size: 20,
                            ),
                            onPressed: () => ref.read(favoritesProvider.notifier).toggle(favTypeVerse, {
                              'id': ayah.id,
                              'text': ayah.text,
                              'surahName': ayah.surahName,
                              'numberInSurah': ayah.numberInSurah,
                            }),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 19),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: ayah.text));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('تم نسخ الآية')));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_rounded, size: 19),
                            onPressed: () => Share.share('${ayah.text}\n[${ayah.surahName}: ${ayah.numberInSurah}]'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomSheet: _showPlayer
          ? QuranPlayerWidget(
              audioUrl: QuranService().surahAudioUrl(settings.reciterId, widget.surahNumber),
              surahName: widget.surahName,
              reciterName: ReciterModel.reciters
                  .firstWhere((r) => r.identifier == settings.reciterId)
                  .name,
            )
          : null,
      floatingActionButton: !_showPlayer
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => setState(() => _showPlayer = true),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            )
          : FloatingActionButton(
              backgroundColor: AppColors.error,
              onPressed: () => setState(() => _showPlayer = false),
              child: const Icon(Icons.close_rounded, color: Colors.white),
            ),
    );
  }
}
