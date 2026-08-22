import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_strings.dart';
import '../../data/azkar_data.dart';
import '../../data/hadith_data.dart';
import '../../providers/quran_provider.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/app_loading.dart';
import '../quran/surah_detail_screen.dart';

/// شاشة بحث عامة وسريعة عبر: السور، الأذكار المحلية، والأحاديث المحلية.
/// البحث داخل نص آيات القرآن الكامل يتم عبر QuranService.searchQuran (يتطلب إنترنت).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final surahListAsync = ref.watch(surahListProvider);

    final matchingAzkar = _query.isEmpty
        ? <String>[]
        : AzkarData.categories
            .expand((c) => c.items)
            .where((i) => i.text.contains(_query))
            .map((i) => i.text)
            .toList();

    final matchingHadiths = _query.isEmpty
        ? <String>[]
        : HadithData.hadiths.where((h) => h.text.contains(_query)).map((h) => h.text).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(hintText: AppStrings.search, border: InputBorder.none),
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('ابدأ الكتابة للبحث في السور والأذكار والأحاديث'))
          : surahListAsync.when(
              loading: () => const AppLoadingList(),
              error: (e, st) => const AppErrorState(),
              data: (surahs) {
                final matchingSurahs = surahs.where((s) => s.name.contains(_query)).toList();
                final results = <Widget>[
                  if (matchingSurahs.isNotEmpty) _sectionTitle('السور (${matchingSurahs.length})'),
                  ...matchingSurahs.map((s) => ListTile(
                        title: Text(s.name, textAlign: TextAlign.right),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SurahDetailScreen(surahNumber: s.number, surahName: s.name),
                        )),
                      )),
                  if (matchingAzkar.isNotEmpty) _sectionTitle('الأذكار (${matchingAzkar.length})'),
                  ...matchingAzkar.map((t) => ListTile(title: Text(t, textAlign: TextAlign.right, maxLines: 2))),
                  if (matchingHadiths.isNotEmpty) _sectionTitle('الأحاديث (${matchingHadiths.length})'),
                  ...matchingHadiths.map((t) => ListTile(title: Text(t, textAlign: TextAlign.right, maxLines: 2))),
                ];
                if (results.isEmpty) {
                  return const AppEmptyState(message: 'لم يتم العثور على نتائج');
                }
                return ListView(children: results);
              },
            ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );
}
