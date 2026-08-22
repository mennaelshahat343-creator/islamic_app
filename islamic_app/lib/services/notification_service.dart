import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import '../models/prayer_times_model.dart';

/// خدمة الإشعارات - تنبيهات الأذان، الأذكار اليومية، الآية والحديث اليومي
/// تتعامل مع صلاحيات Android 13+ وiOS بشكل صحيح
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // نطلبها يدويًا لشرح السبب أولًا
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// طلب صلاحية الإشعارات بشكل صريح (Android 13+ / iOS)
  Future<bool> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    final androidGranted = await androidImpl?.requestNotificationsPermission() ?? true;
    final iosGranted = await iosImpl?.requestPermissions(alert: true, badge: true, sound: true) ?? true;
    return androidGranted && iosGranted;
  }

  NotificationDetails _details({String? soundName}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_channel',
        'مواقيت الصلاة والأذكار',
        channelDescription: 'تنبيهات الأذان والأذكار اليومية',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  /// جدولة تنبيهات كل الصلوات الخمس ليوم واحد بناءً على المواقيت المحسوبة
  Future<void> schedulePrayerAlerts(PrayerTimesModel times, {required Set<String> enabledPrayers}) async {
    await cancelAllPrayerAlerts();
    final entries = times.orderedEntries.where((e) => e.name != 'الشروق');
    int id = 100;
    for (final entry in entries) {
      if (!enabledPrayers.contains(entry.name)) continue;
      if (entry.time.isBefore(DateTime.now())) continue;
      await _scheduleAt(
        id: id++,
        title: 'حان الآن وقت صلاة ${entry.name}',
        body: 'أذّن للصلاة، فحيّ على الصلاة حيّ على الفلاح',
        time: entry.time,
      );
    }
  }

  Future<void> _scheduleAt({required int id, required String title, required String body, required DateTime time}) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      _details(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// جدولة إشعار يومي متكرر (آية/ذكر/حديث اليوم) في وقت ثابت
  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _details(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllPrayerAlerts() async {
    for (int id = 100; id < 106; id++) {
      await _plugin.cancel(id);
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
