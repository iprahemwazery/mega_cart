import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:mega_cart/features/profile/data/get_user_profile_usecase.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/features/profile/damain/user_entity.dart'; // Corrected import to domain

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;

  ProfileCubit(this._getUserProfileUseCase) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    final token = await SessionManager.getToken();

    if (token == null || token.isEmpty) {
      emit(const ProfileError('User not authenticated. Please log in.'));
      return;
    }

    emit(ProfileLoading());
    final result = await _getUserProfileUseCase.call();

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileSuccess(user)),
    );
  }
}
