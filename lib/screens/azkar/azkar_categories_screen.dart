import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/azkar_data.dart';
import 'azkar_detail_screen.dart';

class AzkarCategoriesScreen extends StatelessWidget {
  const AzkarCategoriesScreen({super.key});

  IconData _iconFromName(String name) {
    switch (name) {
      case 'wb_sunny':
        return Icons.wb_sunny_rounded;
      case 'nights_stay':
        return Icons.nights_stay_rounded;
      case 'mosque':
        return Icons.mosque_rounded;
      case 'bedtime':
        return Icons.bedtime_rounded;
      case 'alarm':
        return Icons.alarm_rounded;
      case 'flight_takeoff':
        return Icons.flight_takeoff_rounded;
      case 'volunteer_activism':
        return Icons.volunteer_activism_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.quickAzkar)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: AzkarData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final category = AzkarData.categories[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
                foregroundColor: AppColors.secondary,
                child: Icon(_iconFromName(category.icon)),
              ),
              title: Text(category.title, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text('${category.items.length} ذكر'),
              trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 15),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AzkarDetailScreen(category: category)),
              ),
            ),
          );
        },
      ),
    );
  }
}
