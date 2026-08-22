import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزوّد حالة الاتصال بالإنترنت - يُستخدم لعرض رسائل واضحة بدل الأخطاء التقنية
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
        (results) => !results.contains(ConnectivityResult.none),
      );
});

final isOnlineProvider = FutureProvider<bool>((ref) async {
  final results = await Connectivity().checkConnectivity();
  return !results.contains(ConnectivityResult.none);
});
