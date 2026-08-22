import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/prayer_times_model.dart';
import '../services/location_service.dart';
import '../services/prayer_service.dart';
import '../services/storage_service.dart';
import 'settings_provider.dart';

enum PrayerLoadStatus { initial, loading, loaded, locationDenied, locationServiceOff, error }

class PrayerState {
  final PrayerLoadStatus status;
  final PrayerTimesModel? times;
  final double? latitude;
  final double? longitude;
  final String? cityName;
  final String? errorMessage;

  const PrayerState({
    this.status = PrayerLoadStatus.initial,
    this.times,
    this.latitude,
    this.longitude,
    this.cityName,
    this.errorMessage,
  });

  PrayerState copyWith({
    PrayerLoadStatus? status,
    PrayerTimesModel? times,
    double? latitude,
    double? longitude,
    String? cityName,
    String? errorMessage,
  }) {
    return PrayerState(
      status: status ?? this.status,
      times: times ?? this.times,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      errorMessage: errorMessage,
    );
  }
}

class PrayerNotifier extends StateNotifier<PrayerState> {
  final LocationService _locationService = LocationService();
  final PrayerService _prayerService = PrayerService();
  final Ref ref;

  PrayerNotifier(this.ref) : super(const PrayerState());

  Future<void> loadPrayerTimes({bool forceRefreshLocation = false}) async {
    state = state.copyWith(status: PrayerLoadStatus.loading);
    try {
      double? lat = StorageService.instance.getDouble(AppConstants.keyLastLatitude);
      double? lon = StorageService.instance.getDouble(AppConstants.keyLastLongitude);

      if (forceRefreshLocation || lat == null || lon == null) {
        final locationResult = await _locationService.getCurrentLocation();
        switch (locationResult.status) {
          case LocationStatus.denied:
          case LocationStatus.deniedForever:
            state = state.copyWith(status: PrayerLoadStatus.locationDenied);
            return;
          case LocationStatus.serviceDisabled:
            state = state.copyWith(status: PrayerLoadStatus.locationServiceOff);
            return;
          case LocationStatus.granted:
            lat = locationResult.latitude;
            lon = locationResult.longitude;
            await StorageService.instance.setDouble(AppConstants.keyLastLatitude, lat!);
            await StorageService.instance.setDouble(AppConstants.keyLastLongitude, lon!);
        }
      }

      final method = ref.read(settingsProvider).calculationMethod;
      final times = await _prayerService.getPrayerTimes(
        latitude: lat!,
        longitude: lon!,
        date: DateTime.now(),
        method: method,
      );

      // اسم المدينة غير متوفر بدون حزمة geocoding - نعرض الإحداثيات كبديل بسيط
      final cityLabel = 'الموقع: ${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)}';

      state = state.copyWith(
        status: PrayerLoadStatus.loaded,
        times: times,
        latitude: lat,
        longitude: lon,
        cityName: cityLabel,
      );
    } catch (e) {
      state = state.copyWith(status: PrayerLoadStatus.error, errorMessage: e.toString());
    }
  }
}

final prayerProvider = StateNotifierProvider<PrayerNotifier, PrayerState>((ref) {
  return PrayerNotifier(ref);
});
