import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// عنصر عرض موحّد لكل حالات الخطأ (لا إنترنت، فشل API، لا صلاحية...)
/// مع زر "إعادة المحاولة" - يُستخدم بدل ترك المستخدم أمام شاشة فارغة أو Error تقني
class AppErrorState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? actionLabel;

  const AppErrorState({
    super.key,
    this.icon = Icons.wifi_off_rounded,
    this.title = AppStrings.noInternet,
    this.message = AppStrings.noInternetMsg,
    this.onRetry,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel ?? AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// عنصر عرض "لا توجد عناصر" (مثال: مفضلة فارغة)
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const AppEmptyState({super.key, this.icon = Icons.inbox_rounded, this.message = AppStrings.empty});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
