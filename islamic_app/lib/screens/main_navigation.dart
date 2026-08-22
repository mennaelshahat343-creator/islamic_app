import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import 'home/home_screen.dart';
import 'quran/quran_list_screen.dart';
import 'prayer/prayer_times_screen.dart';
import 'azkar/azkar_categories_screen.dart';
import 'more/more_screen.dart';

/// الهيكل الرئيسي للتنقل (Bottom Navigation) - يحافظ على حالة كل شاشة
/// عبر IndexedStack بدل إعادة بنائها من جديد عند كل تنقل
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuranListScreen(),
    PrayerTimesScreen(),
    AzkarCategoriesScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: AppStrings.navHome),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: AppStrings.navQuran),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_filled_rounded), label: AppStrings.navPrayer),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), label: AppStrings.navAzkar),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: AppStrings.navMore),
        ],
      ),
    );
  }
}
