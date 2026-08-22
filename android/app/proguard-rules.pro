# قواعد ProGuard - تجنب حذف كلاسات مطلوبة من المكتبات المستخدمة

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# just_audio
-keep class com.google.android.exoplayer2.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# Hive
-keep class * extends com.google.gson.TypeAdapter
