import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/prayer_service.dart';
import '../../widgets/home/next_prayer_card.dart';
import '../../widgets/common/app_error_widget.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  String _timeLabel(DateTime t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $period';
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'الفجر':
        return Icons.brightness_4_rounded;
      case 'الشروق':
        return Icons.wb_twilight_rounded;
      case 'الظهر':
        return Icons.wb_sunny_rounded;
      case 'العصر':
        return Icons.sunny_snowing;
      case 'المغرب':
        return Icons.brightness_6_rounded;
      case 'العشاء':
        return Icons.nights_stay_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.quickPrayerTimes),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.tune_rounded),
            onSelected: (method) {
              ref.read(settingsProvider.notifier).setCalculationMethod(method);
              ref.read(prayerProvider.notifier).loadPrayerTimes();
            },
            itemBuilder: (context) => PrayerService.calculationMethods.entries
                .map((e) => PopupMenuItem(
                      value: e.key,
                      child: Row(
                        children: [
                          if (e.key == settings.calculationMethod)
                            const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
        child: switch (state.status) {
          PrayerLoadStatus.loading || PrayerLoadStatus.initial =>
            ListView(children: const [SizedBox(height: 200), Center(child: CircularProgressIndicator())]),
          PrayerLoadStatus.locationDenied => ListView(children: [
              const SizedBox(height: 60),
              AppErrorState(
                icon: Icons.location_off_rounded,
                title: AppStrings.enableLocation,
                message: AppStrings.locationPermissionMsg,
                onRetry: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
                actionLabel: 'تفعيل الموقع',
              ),
            ]),
          PrayerLoadStatus.locationServiceOff => ListView(children: [
              const SizedBox(height: 60),
              AppErrorState(
                icon: Icons.location_disabled_rounded,
                title: 'خدمة الموقع غير مُفعّلة',
                message: 'يرجى تفعيل GPS من إعدادات الجهاز لعرض مواقيت الصلاة الدقيقة.',
                onRetry: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
              ),
            ]),
          PrayerLoadStatus.error => ListView(children: [
              const SizedBox(height: 60),
              AppErrorState(onRetry: () => ref.read(prayerProvider.notifier).loadPrayerTimes()),
            ]),
          PrayerLoadStatus.loaded => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                NextPrayerCard(times: state.times!, cityName: state.cityName),
                const SizedBox(height: 20),
                Text(state.times!.gregorianDate, textAlign: TextAlign.center),
                Text(state.times!.hijriDate, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ...state.times!.orderedEntries.map(
                  (e) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(_iconFor(e.name), color: AppColors.primary),
                      title: Text(e.name),
                      trailing: Text(
                        _timeLabel(e.time),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
