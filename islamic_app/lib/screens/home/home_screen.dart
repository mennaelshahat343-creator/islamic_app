import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/home/home_feature_card.dart';
import '../../widgets/home/next_prayer_card.dart';
import '../../widgets/common/app_error_widget.dart';
import '../quran/quran_list_screen.dart';
import '../azkar/azkar_categories_screen.dart';
import '../qibla/qibla_screen.dart';
import '../prayer/prayer_times_screen.dart';
import '../hadith/hadith_screen.dart';
import '../tasbeeh/tasbeeh_screen.dart';
import '../../data/hadith_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prayerProvider.notifier).loadPrayerTimes();
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.greetingMorning;
    if (hour < 18) return AppStrings.greetingAfternoon;
    return AppStrings.greetingEvening;
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerProvider);
    final hadith = HadithData.hadithOfDay();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$_greeting 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
                    ),
                  ),
                  const Icon(Icons.mosque_rounded, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 16),

              // ---------- بطاقة الصلاة القادمة ----------
              if (prayerState.status == PrayerLoadStatus.loaded && prayerState.times != null)
                NextPrayerCard(times: prayerState.times!, cityName: prayerState.cityName)
              else if (prayerState.status == PrayerLoadStatus.loading)
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppErrorState(
                    icon: Icons.location_off_rounded,
                    title: 'تعذّر تحديد مواقيت الصلاة',
                    message: prayerState.status == PrayerLoadStatus.locationDenied
                        ? AppStrings.locationPermissionMsg
                        : 'تحقق من تفعيل خدمة الموقع (GPS) والاتصال بالإنترنت.',
                    onRetry: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
                  ),
                ),

              const SizedBox(height: 22),
              Text('الوصول السريع', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),

              // ---------- بطاقات الوصول السريع ----------
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: [
                  HomeFeatureCard(
                    icon: Icons.menu_book_rounded,
                    label: AppStrings.quickQuran,
                    color: AppColors.primary,
                    onTap: () => _push(const QuranListScreen()),
                  ),
                  HomeFeatureCard(
                    icon: Icons.favorite_rounded,
                    label: AppStrings.quickAzkar,
                    color: AppColors.secondary,
                    onTap: () => _push(const AzkarCategoriesScreen()),
                  ),
                  HomeFeatureCard(
                    icon: Icons.explore_rounded,
                    label: AppStrings.quickQibla,
                    color: AppColors.gold,
                    onTap: () => _push(const QiblaScreen()),
                  ),
                  HomeFeatureCard(
                    icon: Icons.access_time_filled_rounded,
                    label: AppStrings.quickPrayerTimes,
                    color: AppColors.primary,
                    onTap: () => _push(const PrayerTimesScreen()),
                  ),
                  HomeFeatureCard(
                    icon: Icons.menu_book_outlined,
                    label: AppStrings.quickHadith,
                    color: AppColors.secondary,
                    onTap: () => _push(const HadithScreen()),
                  ),
                  HomeFeatureCard(
                    icon: Icons.fingerprint_rounded,
                    label: AppStrings.quickTasbeeh,
                    color: AppColors.gold,
                    onTap: () => _push(const TasbeehScreen()),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              Text(AppStrings.hadithOfDay, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        hadith.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${hadith.source} - ${hadith.narrator}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
