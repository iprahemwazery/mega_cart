import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/features/profile/cubit/profile_state.dart';
import 'package:mega_cart/features/profile/widget/user_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository userRepository;

  ProfileCubit(this.userRepository) : super(ProfileInitial());

  Future<void> loadUserProfile(String userId) async {
    emit(ProfileLoading());
    final result = await userRepository.getUserProfile(userId);

    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
