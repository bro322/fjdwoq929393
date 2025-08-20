
# تطبيق "معهد فاتنة للدورات التعليمية"

تطبيق Flutter (يعمل أيضاً كتطبيق ويب PWA) لإدارة:
- حسابات الطلاب ومشاهدة العلامات.
- أقسام البرنامج التاسع والبكالوريا (أدبي/علمي).
- قسم خاص بالمعلمين لعرض مواعيد الجلسات والتنبيه بنغمة رنين.
- لوحة تحكم للمدير (أنت فقط) لإضافة/تعديل كل شيء.

> **ملاحظة توافق الأندرويد**: Flutter الحديثة تدعم رسميًا أندرويد 5.0 (API 21) وما فوق. للأجهزة الأقدم مثل 4.2 يمكنهم فتح نسخة الويب (PWA) من التطبيق عبر المتصفح.

## الإعداد السريع

1) ثبّت Flutter 3.x و Android Studio/Xcode.
2) أنشئ مشروع Firebase وأضف تطبيق Android و iOS و Web (اختياري).
3) نزّل ملفات التهيئة وضعها داخل المشروع:
   - Android: ضع `google-services.json` في `android/app/`.
   - iOS: ضع `GoogleService-Info.plist` في `ios/Runner/`.
   - Web: أنشئ ملف `web/firebase-config.js` وضع كائن التهيئة هناك (مثال موجود).
4) فعّل Authentication (Email/Password) و Cloud Firestore.
5) حدّد بريد المدير عبر متغير `adminEmail` داخل `lib/services/auth_service.dart` وأيضاً **كلمة سر سرّية للوحة المدير** `ADMIN_SECRET_CODE` داخل `lib/services/constants.dart`.
6) شغّل:
   ```bash
   flutter pub get
   flutter run -d chrome        # للويب
   flutter run                  # للهاتف
   ```

## بنية قاعدة البيانات (Firestore)

- `users/{uid}`: {role: "student"|"teacher"|"admin", fullName, gradeLevel}
- `grades/{docId}`: {studentId, subject, term, score, notes, createdAt}
- `schedules/{docId}`: {teacherId, title, room, startTime (Timestamp), endTime (Timestamp), note}

## ملاحظات

- التنبيهات المحلية مضبوطة لتُنشأ للمعلم بمجرد مزامنة جدوله من السحابة.
- يمكنك إخفاء أي شاشة/صلاحية بناءً على الدور.
- اللون العام: تدرّج زهري ↔ أزرق كما طُلب.
