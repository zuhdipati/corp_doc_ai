import 'package:corp_doc_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));
}
