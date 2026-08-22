import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// مؤشر تحميل عام (Shimmer) لقوائم البيانات أثناء الجلب من API
class AppLoadingList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const AppLoadingList({super.key, this.itemCount = 6, this.itemHeight = 72});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight,
      highlightColor: isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

/// مؤشر تحميل دائري بسيط بلون التطبيق
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
    );
  }
}
