import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/hadith_data.dart';
import '../../models/hadith_model.dart';
import '../../providers/favorites_provider.dart';

class HadithScreen extends ConsumerWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quickHadith)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: HadithData.hadiths.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _HadithCard(hadith: HadithData.hadiths[index]),
      ),
    );
  }
}

class _HadithCard extends ConsumerWidget {
  final HadithModel hadith;
  const _HadithCard({required this.hadith});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.read(favoritesProvider.notifier).isFavorite(favTypeHadith, hadith.id);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(hadith.text, textAlign: TextAlign.right, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text('${AppStrings.narrator}: ${hadith.narrator}', style: Theme.of(context).textTheme.bodyMedium),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${AppStrings.source}: ${hadith.source}${hadith.grade != null ? ' • ${AppStrings.grade}: ${hadith.grade}' : ''}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFav ? AppColors.error : null,
                    size: 20,
                  ),
                  onPressed: () => ref.read(favoritesProvider.notifier).toggle(favTypeHadith, hadith.toJson()),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 19),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: hadith.text));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الحديث')));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 19),
                  onPressed: () => Share.share('${hadith.text}\n[${hadith.source}]'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
