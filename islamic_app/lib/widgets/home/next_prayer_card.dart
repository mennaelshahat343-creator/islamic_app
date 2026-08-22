import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/prayer_times_model.dart';

/// بطاقة الصلاة القادمة مع عدّاد تنازلي حي
class NextPrayerCard extends StatefulWidget {
  final PrayerTimesModel times;
  final String? cityName;

  const NextPrayerCard({super.key, required this.times, this.cityName});

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  PrayerEntry? _next;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final now = DateTime.now();
    var next = widget.times.nextPrayer(now);
    Duration remaining;
    if (next == null) {
      // بعد العشاء: نحسب الوقت المتبقي حتى فجر الغد تقريبيًا
      final tomorrowFajr = widget.times.fajr.add(const Duration(days: 1));
      remaining = tomorrowFajr.difference(now);
      next = PrayerEntry('الفجر (غدًا)', tomorrowFajr);
    } else {
      remaining = next.time.difference(now);
    }
    if (!mounted) return;
    setState(() {
      _next = next;
      _remaining = remaining;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _timeLabel(DateTime t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mosque_rounded, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                widget.cityName ?? widget.times.hijriDate,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'الصلاة القادمة: ${_next?.name ?? ''}',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          if (_next != null)
            Text(
              _timeLabel(_next!.time),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          const SizedBox(height: 14),
          Text(
            _fmt(_remaining),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          const Text('الوقت المتبقي', style: TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}
