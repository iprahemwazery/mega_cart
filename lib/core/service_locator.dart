import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/features/profile/data/profile_repository_impl.dart';
import 'package:mega_cart/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mega_cart/features/profile/data/get_user_profile_usecase.dart';
import 'package:mega_cart/features/profile/damain/profile_repository.dart'
    as domain;

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  sl.registerLazySingleton(
    () => Dio(BaseOptions(baseUrl: ApiConstans.baseUrl)),
  );
  sl.registerLazySingleton(
    () => ApiService(sl<Dio>()),
  ); // No token parameter needed here

  // Profile Feature
  // Repository
  sl.registerLazySingleton<domain.ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ApiService>()),
  );

  // UseCase
  sl.registerLazySingleton(
    () => GetUserProfileUseCase(sl<domain.ProfileRepository>()),
  );

  // Cubit
  sl.registerFactory(() => ProfileCubit(sl<GetUserProfileUseCase>()));
}
