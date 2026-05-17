import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/settings/view/settings_controller.dart';

class SttingsView extends GetView<SettingsController> {
  const SttingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب العلوي (Drag Handle) لشكل احترافي
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الإعدادات',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          const SizedBox(height: 10),
          _buildSettingTile(
            icon: Icons.notifications_none_rounded,
            title: 'الإشعارات',
            onTap: () => GlassSnackbar.show(message: 'سيتم فتح صفحة الإشعارات'),
          ),
          _buildSettingTile(
            icon: Icons.lock_outline_rounded,
            title: 'تغيير كلمة المرور',
            onTap: () =>
                GlassSnackbar.show(message: 'سيتم فتح صفحة تغيير كلمة المرور'),
          ),
          _buildSettingTile(
            icon: Icons.language_rounded,
            title: 'اللغة',
            onTap: () => GlassSnackbar.show(message: 'سيتم فتح خيارات اللغة'),
          ),
          _buildSettingTile(
            icon: Icons.info_outline_rounded,
            title: 'حول التطبيق',
            onTap: () =>
                GlassSnackbar.show(message: ' سيتم فتح صفحة حول التطبيق'),
          ),
          const SizedBox(height: 30), // مساحة سفلية لإعطاء راحة للعين
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue[800]),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
