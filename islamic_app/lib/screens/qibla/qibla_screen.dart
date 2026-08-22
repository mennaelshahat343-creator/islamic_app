import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/prayer_provider.dart';
import '../../services/location_service.dart';
import '../../widgets/common/app_error_widget.dart';

/// شاشة بوصلة القبلة - تستخدم GPS (لحساب زاوية القبلة) + Magnetometer
/// عبر حزمة flutter_compass (اتجاه الجهاز الحالي) لتحديد اتجاه الكعبة المشرفة
class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  double? _distanceKm;
  double? _qiblaBearing;

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerProvider);

    if (prayerState.latitude == null || prayerState.longitude == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.qiblaDirection)),
        body: AppErrorState(
          icon: Icons.location_off_rounded,
          title: AppStrings.enableLocation,
          message: AppStrings.locationPermissionMsg,
          onRetry: () => ref.read(prayerProvider.notifier).loadPrayerTimes(forceRefreshLocation: true),
        ),
      );
    }

    final locationService = LocationService();
    _distanceKm ??= locationService.distanceInKm(
      prayerState.latitude!,
      prayerState.longitude!,
      AppConstants.kaabaLatitude,
      AppConstants.kaabaLongitude,
    );
    _qiblaBearing ??= locationService.qiblaBearing(
      prayerState.latitude!,
      prayerState.longitude!,
      AppConstants.kaabaLatitude,
      AppConstants.kaabaLongitude,
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.qiblaDirection)),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (!snapshot.hasData || snapshot.data?.heading == null) {
            return const AppErrorState(
              icon: Icons.explore_off_rounded,
              title: 'الحساس غير متوفر',
              message: AppStrings.qiblaNoSensor,
            );
          }

          final heading = snapshot.data!.heading!; // اتجاه الجهاز الحالي (0-360 من الشمال)
          // زاوية دوران السهم = اتجاه القبلة المطلق ناقص اتجاه الجهاز الحالي
          final needleAngle = (_qiblaBearing! - heading) * (math.pi / 180);

          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                '${AppStrings.distanceToMakkah}: ${_distanceKm!.toStringAsFixed(0)} كم',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: -heading * (math.pi / 180),
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 2),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: const [
                              Positioned(top: 8, child: Text('N', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                              Positioned(bottom: 8, child: Text('S', style: TextStyle(color: AppColors.lightTextSecondary))),
                              Positioned(right: 8, child: Text('E', style: TextStyle(color: AppColors.lightTextSecondary))),
                              Positioned(left: 8, child: Text('W', style: TextStyle(color: AppColors.lightTextSecondary))),
                            ],
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: needleAngle,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mosque_rounded, size: 30, color: AppColors.gold),
                            Container(
                              width: 6,
                              height: 120,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '${_qiblaBearing!.toStringAsFixed(1)}°',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.qiblaCalibrate,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
