import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mega_cart/core/animations/page_animation_wrapper.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/profile/damain/profile_conttroller.dart';
import 'package:mega_cart/features/settings/widget/settings_controller.dart';
import 'package:mega_cart/features/settings/view/sttings_view.dart';
import 'package:mega_cart/features/profile/presentation/widget/profile_action_card.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimationLimiter(
        child: Column(
          children: PageAnimationWrapper.staggeredList(
            verticalOffset: 50.0,
            children: [
              ProfileActionCard(
                icon: Icons.edit,
                title: 'editProfile'.tr,
                onTap: () {
                  GlassSnackbar.show(message: 'editProfileMessage'.tr);
                },
              ),
              ProfileActionCard(
                icon: Icons.settings,
                title: 'settings'.tr,
                onTap: () {
                  if (!Get.isRegistered<SettingsController>()) {
                    Get.put(SettingsController());
                  }
                  Get.bottomSheet(
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      child: const SttingsView(),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
              ProfileActionCard(
                icon: Icons.add_circle_outline,
                title: 'addNewProduct'.tr,
                onTap: () => Get.toNamed(AppRoutes.createProduct),
              ),
              ProfileActionCard(
                icon: Icons.notifications,
                title: 'notifications'.tr,
                onTap: () {
                  GlassSnackbar.show(message: 'notificationsMessage'.tr);
                },
              ),
              ProfileActionCard(
                icon: Icons.help_outline,
                title: 'helpAndSupport'.tr,
                onTap: () {
                  GlassSnackbar.show(message: 'helpSupportMessage'.tr);
                },
              ),
              ProfileActionCard(
                icon: Icons.logout,
                title: 'logout'.tr,
                isDestructive: true,
                onTap: () => _showLogoutDialog(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'logout'.tr,
      middleText: 'logoutConfirmation'.tr,
      textConfirm: 'yes'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        try {
          // نحاول الوصول للكنترولر المسجل
          if (Get.isRegistered<ProfileConttroller>()) {
            Get.find<ProfileConttroller>().logout();
          } else {
            // لو مش موجود ننشئه وننادي Logout
            Get.put(ProfileConttroller()).logout();
          }
        } catch (e) {
          //Fallback في حالة فشل GetX تماماً
          ProfileConttroller().logout();
        }

        if (Get.isOverlaysOpen) Get.back(); // قفل الديالوج
        GlassSnackbar.show(message: 'logoutSuccessMessage'.tr);
      },
    );
  }
}
