import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/service_locator.dart';
import 'package:mega_cart/features/profile/presentation/cubit/profile_cubit.dart'; // Corrected import

import 'package:mega_cart/features/profile/presentation/widget/profile_header.dart';
import 'package:mega_cart/features/profile/presentation/widget/profile_actions.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // For demonstration, we'll use a hardcoded user ID.
    // In a real app, this would come from authentication.

    return BlocProvider(
      // Use sl to inject the Cubit with all its hierarchy
      create: (context) => sl<ProfileCubit>()..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(title: Text('profile'.tr), centerTitle: true),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileSuccess) {
              final user = state.user;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 90.h,
                ),
                child: Column(
                  children: [
                    ProfileHeader(
                      userName: user.name,
                      userEmail: user.email,
                      profilePictureUrl: user.profilePictureUrl,
                    ),
                    const SizedBox(height: 20),
                    const ProfileActions(),
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
                        // Call fetchProfile
                        context.read<ProfileCubit>().fetchProfile();
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
}
