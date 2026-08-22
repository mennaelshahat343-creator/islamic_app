import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/splash/splash_screen.dart';

/// الودجت الجذر للتطبيق - يضبط الثيم، اتجاه RTL، ودعم اللغة العربية
class IslamicApp extends ConsumerWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // ---------- دعم اللغة العربية و RTL ----------
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'), // العربية - أساسية
        Locale('en'), // الإنجليزية - جاهزة للتفعيل المستقبلي عبر l10n
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: const SplashScreen(),
    );
  }
}
