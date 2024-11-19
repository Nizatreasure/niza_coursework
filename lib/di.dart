import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'app/authentication/data/repositories/auth_repository_impl.dart';
import 'app/authentication/domain/usecases/login_usecase.dart';
import 'app/authentication/domain/usecases/logout_usecase.dart';
import 'app/authentication/presentation/blocs/login_bloc/login_bloc.dart';
import 'app/home/data/repositories/home_repository_impl.dart';
import 'app/home/domain/usecases/fetch_data_usecase.dart';
import 'app/home/presentation/blocs/homepage_bloc/homepage_bloc.dart';
import 'app/home/presentation/blocs/plot_bloc/plot_bloc.dart';
import 'core/common/network/connection_checker.dart';
import 'core/services/network_request_service.dart';

final getIt = GetIt.instance;

Future<void> initializaDependencies() async {
  //services
  getIt.registerSingleton<InternetConnectionChecker>(
      InternetConnectionChecker());
  getIt.registerSingleton<ConnectionChecker>(ConnectionCheckerImpl(getIt()));
  getIt
      .registerSingleton<NetworkRequestService>(NetworkRequestService(getIt()));

  //repository
  getIt.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl(getIt()));
  getIt.registerSingleton<HomeRepository>(HomeRepositoryImpl(getIt()));

  //usecase
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt()));
  getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(getIt()));
  getIt.registerSingleton<FetchDataUsecase>(FetchDataUsecase(getIt()));

  //blocs
  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt()));
  getIt.registerFactory<HomepageBloc>(() => HomepageBloc());
  getIt.registerFactory<PlotBloc>(() => PlotBloc(getIt()));
}
