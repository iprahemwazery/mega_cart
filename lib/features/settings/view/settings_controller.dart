import 'package:get/get.dart';

class SettingsController extends GetxController {
  // يمكنك إضافة متغيرات التحكم هنا، مثل حالة الإشعارات أو اللغة
  var isNotificationsEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void changeLanguage() {
    // منطق تغيير اللغة
  }

  void changePassword() {
    // منطق تغيير كلمة المرور
  }

  void showAboutApp() {
    // عرض معلومات التطبيق
  }
}
