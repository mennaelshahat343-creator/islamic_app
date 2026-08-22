import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/common/app_error_widget.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoritesProvider); // إعادة البناء عند أي تعديل

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.favorites),
          bottom: const TabBar(tabs: [
            Tab(text: 'الآيات'),
            Tab(text: 'الأحاديث'),
            Tab(text: 'الأذكار'),
          ]),
        ),
        body: TabBarView(
          children: [
            _FavList(type: favTypeVerse, ref: ref),
            _FavList(type: favTypeHadith, ref: ref),
            _FavList(type: favTypeAzkar, ref: ref),
          ],
        ),
      ),
    );
  }
}

class _FavList extends StatelessWidget {
  final String type;
  final WidgetRef ref;
  const _FavList({required this.type, required this.ref});

  @override
  Widget build(BuildContext context) {
    final items = ref.read(favoritesProvider.notifier).byType(type);
    if (items.isEmpty) {
      return const AppEmptyState(icon: Icons.favorite_border_rounded, message: 'لا توجد عناصر في المفضلة بعد');
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        final text = item['text']?.toString() ?? '';
        return Card(
          child: ListTile(
            title: Text(text, textAlign: TextAlign.right, maxLines: 3, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggle(type, {'id': item['id']});
              },
            ),
          ),
        );
      },
    );
  }
}
