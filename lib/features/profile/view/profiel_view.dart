import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/profile/data/profile_conttroller.dart';
import 'package:mega_cart/features/profile/widget/profile_cubit.dart';
import 'package:mega_cart/features/profile/widget/profile_state.dart';
import 'package:mega_cart/features/profile/widget/user_remote_data_source.dart';
import 'package:mega_cart/features/profile/widget/user_repository_impl.dart';
import 'package:mega_cart/features/settings/view/sttings_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // For demonstration, we'll use a hardcoded user ID.
    // In a real app, this would come from authentication.
    const String userId = 'user123';
    // final controller = Get.put(HomeController());

    return BlocProvider(
      create: (context) {
        final dio = Dio(BaseOptions(baseUrl: ApiConstans.baseUrl));
        final remoteDataSource = UserRemoteDataSourceImpl(dio);
        final userRepository = UserRepositoryImpl(remoteDataSource);
        return ProfileCubit(userRepository)..loadUserProfile(userId);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('profile'.tr), centerTitle: true),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileHeader(
                      context,
                      user.name,
                      user.email,
                      user.profilePictureUrl,
                    ),
                    const SizedBox(height: 20),
                    _buildProfileActions(context),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'error'.trParams({'errorMessage': state.message}),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileCubit>().loadUserProfile(userId);
                      },
                      child: Text('retry'.tr),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String userName,
    String? userEmail,
    String? profilePictureUrl,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profilePictureUrl ?? '',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            userName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            userEmail ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildActionCard(
            context,
            icon: Icons.edit,
            title: 'editProfile'.tr,
            onTap: () {
              GlassSnackbar.show(message: 'سيتم فتح صفحة تعديل الملف الشخصي');
            },
          ),
          _buildActionCard(
            context,
            icon: Icons.settings,
            title: 'settings'.tr,
            onTap: () {
              Get.bottomSheet(
                // Wrap SttingsView with a Container to give it a background color
                // and then apply the shape to the Get.bottomSheet itself.
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).scaffoldBackgroundColor, // Background color for the sheet content
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),

                  child: const SttingsView(),
                ),
                isScrollControlled:
                    true, // Allows the bottom sheet to take full height if needed
                backgroundColor:
                    Colors.transparent, // Important for rounded corners to show
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
              );
            },
          ),
          _buildActionCard(
            context,
            icon: Icons.notifications,
            title: 'notifications'.tr,
            onTap: () {
              GlassSnackbar.show(message: 'سيتم فتح صفحة الإشعارات');
            },
          ),
          _buildActionCard(
            context,
            icon: Icons.help_outline,
            title: 'helpAndSupport'.tr,
            onTap: () {
              GlassSnackbar.show(message: 'سيتم فتح صفحة المساعدة والدعم');
            },
          ),
          _buildActionCard(
            context,
            icon: Icons.logout,
            title: 'logout'.tr,
            isDestructive: true,
            onTap: () {
              Get.defaultDialog(
                title: 'logout'.tr,
                middleText: 'logoutConfirmation'.tr,
                textConfirm: 'yes'.tr,
                textCancel: 'cancel'.tr,
                confirmTextColor: Colors.white,
                onConfirm: () {
                  ProfileConttroller().logout();
                  GlassSnackbar.show(message: 'تم تسجيل الخروج بنجاح');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(
                  context,
                ).colorScheme.primary, // استخدام colorScheme.error
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            // استخدام TextTheme لتوحيد الخطوط
            color: isDestructive
                ? Theme.of(context).colorScheme.error
                : Theme.of(
                    context,
                  ).colorScheme.onSurface, // استخدام لون يتفاعل مع الثيم
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}
