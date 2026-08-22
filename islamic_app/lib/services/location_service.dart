import 'package:geolocator/geolocator.dart';

/// نتيجة طلب الموقع، تحتوي على حالة واضحة للتعامل مع كل السيناريوهات
enum LocationStatus { granted, denied, deniedForever, serviceDisabled }

class LocationResult {
  final LocationStatus status;
  final double? latitude;
  final double? longitude;

  LocationResult({required this.status, this.latitude, this.longitude});
}

/// خدمة الموقع الجغرافي - تُستخدم لمواقيت الصلاة واتجاه القبلة
/// يجب دائمًا شرح سبب الاستخدام للمستخدم قبل طلب الإذن (راجع شاشة طلب الإذن)
///
/// ملاحظة: لا نستخدم حزمة geocoding لتحويل الإحداثيات إلى اسم مدينة، إبقاءً
/// للاعتماديات مطابقة لملف pubspec.yaml الحالي. إن رغبت بعرض اسم المدينة،
/// أضف حزمة geocoding إلى pubspec.yaml ثم استخدم placemarkFromCoordinates هنا.
class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(status: LocationStatus.serviceDisabled);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult(status: LocationStatus.denied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResult(status: LocationStatus.deniedForever);
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return LocationResult(
      status: LocationStatus.granted,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// حساب المسافة بالكيلومترات بين موقعين (تُستخدم لمسافة الكعبة)
  double distanceInKm(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// حساب زاوية اتجاه القبلة (بيرنغ) من موقع المستخدم إلى الكعبة المشرفة
  double qiblaBearing(double lat, double lon, double kaabaLat, double kaabaLon) {
    return Geolocator.bearingBetween(lat, lon, kaabaLat, kaabaLon);
  }
}
