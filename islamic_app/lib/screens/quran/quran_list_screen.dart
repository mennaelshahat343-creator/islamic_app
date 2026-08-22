import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/surah_model.dart';
import '../../providers/quran_provider.dart';
import '../../services/storage_service.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/common/app_error_widget.dart';
import 'surah_detail_screen.dart';

class QuranListScreen extends ConsumerStatefulWidget {
  const QuranListScreen({super.key});

  @override
  ConsumerState<QuranListScreen> createState() => _QuranListScreenState();
}

class _QuranListScreenState extends ConsumerState<QuranListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final surahListAsync = ref.watch(surahListProvider);
    final lastPosition = StorageService.instance.getLastPosition();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quickQuran)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: AppStrings.searchSurah,
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Theme.of(context).cardTheme.color,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          if (lastPosition != null && _query.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: AppColors.primary.withValues(alpha: 0.08),
                child: ListTile(
                  leading: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                  title: const Text(AppStrings.continueReading),
                  subtitle: Text('السورة رقم ${lastPosition['surah']} - آية ${lastPosition['ayah']}'),
                  trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(
                        surahNumber: lastPosition['surah']!,
                        surahName: '',
                        scrollToAyah: lastPosition['ayah'],
                      ),
                    ));
                  },
                ),
              ),
            ),
          const SizedBox(height: 6),
          Expanded(
            child: surahListAsync.when(
              loading: () => const AppLoadingList(itemCount: 10),
              error: (err, st) => AppErrorState(
                onRetry: () => ref.invalidate(surahListProvider),
              ),
              data: (surahs) {
                final filtered = _query.isEmpty
                    ? surahs
                    : surahs
                        .where((s) =>
                            s.name.contains(_query) ||
                            s.englishName.toLowerCase().contains(_query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty) {
                  return const AppEmptyState(message: 'لم يتم العثور على نتائج');
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _SurahTile(surah: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final SurahModel surah;
  const _SurahTile({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          foregroundColor: AppColors.primary,
          child: Text('${surah.number}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        title: Text(surah.name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.right),
        subtitle: Text(
          '${surah.isMakki ? AppStrings.makkiyah : AppStrings.madaniyah} • ${surah.numberOfAyahs} ${AppStrings.verses}',
          textAlign: TextAlign.right,
        ),
        trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 15),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SurahDetailScreen(surahNumber: surah.number, surahName: surah.name),
          ));
        },
      ),
    );
  }
}
