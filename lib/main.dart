import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsBinding.ensureInitialized();

  // تهيئة التخزين المحلي (Hive + SharedPreferences) قبل تشغيل التطبيق
  await StorageService.instance.init();

  // تهيئة نظام الإشعارات (الأذان، التذكيرات اليومية)
  await NotificationService.instance.init();

  runApp(const ProviderScope(child: IslamicApp()));
}
