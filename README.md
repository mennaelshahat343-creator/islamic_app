# نور - تطبيق إسلامي شامل (Al-Huda Islamic App)

تطبيق إسلامي شامل مبني بـ Flutter (Android + iOS)، يتضمن القرآن الكريم، مواقيت
الصلاة، اتجاه القبلة، الأذكار، التسبيح، والأحاديث النبوية.

---

## 🚀 خطوات التشغيل

### 1. تثبيت Flutter
```bash
# من الموقع الرسمي:
https://docs.flutter.dev/get-started/install

# تأكد من التثبيت:
flutter doctor
```

### 2. فتح المشروع في Android Studio
```
File → Open → اختر مجلد islamic_app
```

### 3. تثبيت المكتبات
```bash
flutter pub get
```

### 4. تشغيل التطبيق
```bash
# على جهاز متصل
flutter run

# أو build APK
flutter build apk --release
```

---

## ⚠️ ملاحظات مهمة جدًا قبل أول تشغيل

### أ) توافق Gradle مع Java
إن ظهرت رسالة خطأ من نوع "Gradle build failed due to Java/Gradle
incompatibility" عند فتح المشروع (شائعة مع Java 21+)، افتح
`android/gradle/wrapper/gradle-wrapper.properties` وتأكد أن `distributionUrl`
يشير إلى نسخة Gradle 8.5 أو أحدث (تم ضبطه مسبقًا هنا على 8.10.2). إذا استمرت
المشكلة بعد ذلك، جرّب:
```bash
flutter clean
flutter pub get
```

### ب) ملف gradle-wrapper.jar
هذا المشروع لا يتضمن الملف الثنائي `gradle-wrapper.jar` (لا يمكن توليده بدون
اتصال بالإنترنت أثناء إعداد المشروع). عند فتح المشروع لأول مرة في Android
Studio، سيطلب منك الـ IDE تلقائيًا مزامنة/تنزيل Gradle Wrapper — وافق على ذلك
وسيُنشأ الملف تلقائيًا. إن لم يحدث ذلك، شغّل من داخل مجلد `android/`:
```bash
gradle wrapper --gradle-version 8.10.2
```
(يتطلب تثبيت Gradle على جهازك مسبقًا لمرة واحدة فقط).

### ج) الخطوط العربية
يستخدم التطبيق حزمة `google_fonts` (تُحمَّل الخطوط تلقائيًا عند أول تشغيل
مع اتصال إنترنت) بدل تضمين ملفات خطوط محلية، لأن ملفات .ttf الفعلية لخطوط
Amiri/Cairo/Scheherazade غير مرفقة بالمشروع. إذا أردت خطوطًا محلية تعمل بدون
إنترنت، ضع ملفات .ttf الحقيقية في `assets/fonts/` وفعّل قسم `fonts:` المُعلّق
داخل `pubspec.yaml`، ثم استبدل استدعاءات `GoogleFonts.cairo(...)` في
`lib/core/theme/app_theme.dart` بخط `Cairo`/`Amiri` المحلي.

### د) أيقونة التطبيق
تم توليد أيقونات placeholder بسيطة (دائرة خضراء بهلال ذهبي) في مجلدات
`android/app/src/main/res/mipmap-*/`. استبدلها بأيقونتك الاحترافية النهائية
قبل النشر، ويفضّل استخدام حزمة `flutter_launcher_icons` لتوليدها تلقائيًا
لكل الأحجام دفعة واحدة.

### هـ) صوت الأذان
مسار `assets/audio/adhan.mp3` غير مرفق فعليًا (لتفادي مشاكل حقوق الاستخدام).
أضف ملف الأذان الخاص بك في هذا المسار — المجلد نفسه مُدرَج بالفعل في
`pubspec.yaml` ضمن `assets:`.

---

## 📦 APIs المستخدمة فعليًا في الكود الحالي

### 1. مواقيت الصلاة + التقويم الهجري
**المصدر:** [api.aladhan.com](https://aladhan.com/prayer-times-api) — مطبَّق في `lib/services/prayer_service.dart`
```
GET https://api.aladhan.com/v1/timings/{timestamp}?latitude={lat}&longitude={lng}&method={method}
```

### 2. القرآن الكريم + التلاوات الصوتية
**المصدر:** [api.alquran.cloud](https://alquran.cloud/api) — مطبَّق في `lib/services/quran_service.dart`
```
GET https://api.alquran.cloud/v1/surah                          # جميع السور
GET https://api.alquran.cloud/v1/surah/{number}/quran-uthmani   # آيات سورة (نص عثماني)
GET https://api.alquran.cloud/v1/search/{q}/all/ar              # بحث في القرآن
GET https://cdn.islamic.network/quran/audio-surah/128/{reciter}/{surah}.mp3  # تلاوة صوتية
```

### 3. القبلة والمسافة إلى مكة
تُحسب محليًا رياضيًا (بدون API) عبر `Geolocator.bearingBetween` و
`Geolocator.distanceBetween` في `lib/services/location_service.dart`، مع
اتجاه الجهاز الحالي عبر حزمة `flutter_compass`.

### 4. الأحاديث النبوية
**الحالة الحالية:** بيانات محلية أساسية موثقة المصدر (البخاري ومسلم) في
`lib/data/hadith_data.dart` — تعمل بدون إنترنت بالكامل.

**لتوسيعها لاحقًا عبر API** (اختياري)، يمكن ربط:
```
GET https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/ara-bukhari.json
GET https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/ara-bukhari/{number}.json
```
الكتب المتاحة في هذا المصدر: `ara-bukhari`, `ara-muslim`, `ara-tirmidhi`,
`ara-abudawud`, `ara-nasai`, `ara-ibnmajah`, `ara-nawawi`.

### 5. الأذكار
بيانات محلية (`lib/data/azkar_data.dart`) مقتبسة من "حصن المسلم" — تعمل
Offline بالكامل. يحتوي الملف على مجموعة أساسية لكل فئة؛ يوصى بإكمال القائمة
كاملة (200+ ذكر) من نسخة رقمية موثوقة لاحقًا.

---

## 📁 هيكل المشروع

```
islamic_app/
├── android/                  # مشروع Android (Gradle, Manifest, أيقونات)
├── assets/
│   ├── data/                 # بيانات إضافية (اختياري)
│   ├── images/                # الصور
│   └── audio/                 # ملفات صوتية (أضف adhan.mp3 هنا)
├── lib/
│   ├── main.dart               # نقطة الدخول
│   ├── app.dart                 # الودجت الجذر (Theme, RTL, Locale)
│   ├── core/
│   │   ├── constants/          # الألوان، النصوص، الثوابت العامة
│   │   └── theme/               # الثيم الفاتح/الداكن
│   ├── models/                  # نماذج البيانات (Surah, Ayah, PrayerTimes...)
│   ├── services/                 # خدمات APIs والتخزين والإشعارات والصوت
│   ├── providers/                # إدارة الحالة (Riverpod)
│   ├── data/                     # بيانات محلية (أذكار، أحاديث)
│   ├── screens/                  # الشاشات (home, quran, prayer, qibla, azkar...)
│   └── widgets/                   # عناصر واجهة مشتركة
└── pubspec.yaml
```

---

## ✨ حالة المزايا

| الميزة | الحالة |
|--------|--------|
| 📖 القرآن الكريم (114 سورة، نص + بحث) | ✅ عبر API |
| 🎵 تلاوة صوتية (مشغّل كامل: Play/Pause/Seek/Volume) | ✅ عبر API + just_audio |
| ⏰ مواقيت الصلاة حسب الموقع + طرق حساب متعددة | ✅ عبر API |
| 📅 التقويم الهجري | ✅ ضمن استجابة مواقيت الصلاة |
| 🧭 اتجاه القبلة (بوصلة حية) + المسافة إلى مكة | ✅ GPS + flutter_compass |
| 🙏 الأذكار (صباح/مساء/نوم/سفر...) بعدّاد لكل ذكر | ✅ محلي بالكامل |
| 📿 التسبيح الإلكتروني مع اهتزاز اختياري | ✅ محلي بالكامل |
| 📝 الأحاديث النبوية (حديث اليوم + مشاركة/نسخ) | ✅ محلي (قابل للتوسيع بـ API) |
| ⭐ المفضلة (آيات/أحاديث/أذكار) | ✅ محلي عبر Hive |
| 🌙 الوضع الليلي/النهاري/تلقائي | ✅ |
| 🔤 حجم خط قابل للتعديل للقرآن | ✅ |
| 🔄 دعم RTL كامل للعربية | ✅ |
| 📴 عمل Offline (أذكار، أحاديث، مفضلة، تسبيح، آخر موضع قراءة) | ✅ |
| 🔔 إشعارات الأذان اليومية (مجدولة) | ✅ flutter_local_notifications |
| 🔎 بحث عام (سور، أذكار، أحاديث محليًا) | ✅ |

---

## 🔧 Permissions المطلوبة (Android)

مضبوطة بالفعل في `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

كل صلاحية تُطلب من المستخدم بشكل صريح مع شرح السبب في الواجهة قبل الطلب
الفعلي (راجع `AppStrings.locationPermissionMsg` كمثال).

---

## 🍎 iOS

هذا المشروع يتضمن حاليًا كود Dart/Flutter عابر المنصات بالكامل (يعمل على
iOS دون تعديل) وملفات Android الكاملة. مجلد `ios/` القياسي (Xcode project,
Info.plist, Podfile) غير مُولَّد بعد ضمن هذا التسليم.

لإنشائه: بعد فك ضغط المشروع، شغّل من مجلد `islamic_app/`:
```bash
flutter create --platforms=ios .
```
هذا سيولّد مجلد `ios/` قياسيًا متوافقًا مع بقية المشروع تلقائيًا. بعدها أضف
في `ios/Runner/Info.plist` مفاتيح شرح صلاحية الموقع والإشعارات:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>نحتاج موقعك لحساب مواقيت الصلاة واتجاه القبلة بدقة.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>نحتاج موقعك لحساب مواقيت الصلاة واتجاه القبلة بدقة.</string>
```
ثم:
```bash
cd ios && pod install
```

---

## 🧪 اختبار Android
```bash
flutter run -d <device_id>
# أو لمعرفة الأجهزة المتاحة:
flutter devices
```

## 🧪 اختبار iOS
يتطلب جهاز Mac مع Xcode مثبت:
```bash
flutter run -d <ios_device_id>
```

---

## 🔑 مفاتيح API

لا يحتاج المشروع حاليًا لأي مفتاح API — كل المصادر المستخدمة
(AlQuran Cloud، Aladhan) مجانية ومفتوحة بدون تسجيل. إن قررت ربط
Sunnah.com API لاحقًا للأحاديث، ستحتاج مفتاحًا مجانيًا عبر التسجيل في
https://sunnah.api-docs.io.

---

## 📌 للنشر على المتاجر

1. غيّر `applicationId` في `android/app/build.gradle` (حاليًا `com.nour.islamic_app`).
2. أنشئ ملف توقيع (`key.jks`) واربطه في `signingConfigs` بدل `signingConfigs.debug`.
3. استبدل الأيقونات placeholder بأيقونة احترافية نهائية.
4. راجع سياسة الخصوصية فعليًا قبل رفع التطبيق (لا تُجمع أي بيانات شخصية حاليًا).
