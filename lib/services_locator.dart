import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Core/Services/auth_local_services.dart';
import 'Core/Services/auth_remote_services.dart';
import 'core/Network/network_connection_checker.dart';
import 'Features/Auth/ViewModel/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> servicesLocator() async {
  //! Features

  // Auth Bloc

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      authLocalServices: sl(),
      authRemoteServices: sl(),
      networkConnectionChecker: sl(),
    ),
  );

  // Instagram Bloc
  // sl.registerLazySingleton<InstagramCubit>(
  //   () => InstagramCubit(
  //     instagramRemoteServices: sl<InstagramRemoteServices>(),
  //     instagramLocalServices: sl<InstagramLocalServices>(),
  //     networkConnectionChecker: sl<NetworkConnectionChecker>(),
  //   ),
  // );
  //! Core

  //Auth Services
  sl.registerLazySingleton<NetworkConnectionChecker>(
      () => NetworkConnectionCheckerImpl(sl()));
  sl.registerLazySingleton<AuthLocalServices>(
      () => AuthLocalServicesSharedPrefes(sl()));
  sl.registerLazySingleton<AuthRemoteServices>(
      () => AuthRemoteServicesFireBase());
  // //Maps Services
  // sl.registerLazySingleton<InstagramLocalServices>(
  //     () => InstagramLocalServicesSharedPrefes(sl<SharedPreferences>()));
  // sl.registerLazySingleton<InstagramRemoteServices>(
  //     () => InstagramRemoteServicesGeoLocator());

  //! External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
