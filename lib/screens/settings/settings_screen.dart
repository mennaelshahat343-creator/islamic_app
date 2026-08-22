import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/prayer_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        children: [
          _SectionHeader(title: 'المظهر'),
          SwitchListTile(
            title: const Text(AppStrings.darkMode),
            secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.primary),
            value: themeMode == ThemeMode.dark,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_auto_rounded, color: AppColors.primary),
            title: const Text('الوضع التلقائي (حسب النظام)'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (v) => ref.read(themeModeProvider.notifier).setThemeMode(v!),
            ),
          ),

          _SectionHeader(title: 'القرآن الكريم'),
          ListTile(
            leading: const Icon(Icons.text_fields_rounded, color: AppColors.primary),
            title: const Text(AppStrings.fontSize),
            subtitle: Slider(
              value: settings.quranFontSize,
              min: 16,
              max: 34,
              divisions: 18,
              activeColor: AppColors.primary,
              label: settings.quranFontSize.toStringAsFixed(0),
              onChanged: (v) => ref.read(settingsProvider.notifier).setFontSize(v),
            ),
          ),

          _SectionHeader(title: 'مواقيت الصلاة'),
          ListTile(
            leading: const Icon(Icons.calculate_rounded, color: AppColors.primary),
            title: const Text(AppStrings.calculationMethod),
            subtitle: Text(PrayerService.calculationMethods[settings.calculationMethod] ?? ''),
            trailing: const Icon(Icons.arrow_drop_down_rounded),
            onTap: () => _showMethodPicker(context, ref, settings.calculationMethod),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_rounded, color: AppColors.primary),
            title: const Text('تحديث الموقع'),
            trailing: const Icon(Icons.refresh_rounded),
            onTap: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
          ),

          _SectionHeader(title: 'الإشعارات'),
          SwitchListTile(
            title: const Text('تفعيل إشعارات الأذان'),
            secondary: const Icon(Icons.notifications_active_rounded, color: AppColors.primary),
            value: settings.notificationsEnabled,
            onChanged: (v) => ref.read(settingsProvider.notifier).setNotificationsEnabled(v),
          ),
          ...['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'].map(
            (name) => CheckboxListTile(
              title: Text('تنبيه $name'),
              value: settings.enabledPrayerAlerts.contains(name),
              activeColor: AppColors.primary,
              onChanged: settings.notificationsEnabled
                  ? (v) => ref.read(settingsProvider.notifier).togglePrayerAlert(name, v ?? false)
                  : null,
            ),
          ),

          _SectionHeader(title: 'حول'),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded, color: AppColors.primary),
            title: Text(AppStrings.about),
            subtitle: Text('${AppStrings.appName} - ${AppStrings.appTagline}\nالإصدار 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
            title: Text(AppStrings.privacy),
            subtitle: Text('لا نجمع أي بيانات شخصية غير ضرورية. الموقع يُستخدم محليًا لحساب مواقيت الصلاة والقبلة فقط.'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showMethodPicker(BuildContext context, WidgetRef ref, int current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: PrayerService.calculationMethods.entries.map((e) {
            return RadioListTile<int>(
              value: e.key,
              groupValue: current,
              title: Text(e.value, textAlign: TextAlign.right),
              onChanged: (v) {
                ref.read(settingsProvider.notifier).setCalculationMethod(v!);
                ref.read(prayerProvider.notifier).loadPrayerTimes();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary),
      ),
    );
  }
}
