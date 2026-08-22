import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../qibla/qibla_screen.dart';
import '../hadith/hadith_screen.dart';
import '../tasbeeh/tasbeeh_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import '../search/search_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoreItem(Icons.explore_rounded, AppStrings.quickQibla, AppColors.gold, const QiblaScreen()),
      _MoreItem(Icons.menu_book_outlined, AppStrings.quickHadith, AppColors.secondary, const HadithScreen()),
      _MoreItem(Icons.fingerprint_rounded, AppStrings.quickTasbeeh, AppColors.primary, const TasbeehScreen()),
      _MoreItem(Icons.favorite_rounded, AppStrings.favorites, AppColors.error, const FavoritesScreen()),
      _MoreItem(Icons.search_rounded, AppStrings.search, AppColors.secondary, const SearchScreen()),
      _MoreItem(Icons.settings_rounded, AppStrings.settings, AppColors.primaryDark, const SettingsScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navMore)),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.3,
        children: items.map((item) {
          return Material(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.screen)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 32, color: item.color),
                    const SizedBox(height: 10),
                    Text(item.label, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String label;
  final Color color;
  final Widget screen;
  _MoreItem(this.icon, this.label, this.color, this.screen);
}
