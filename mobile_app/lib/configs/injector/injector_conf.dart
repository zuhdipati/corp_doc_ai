import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'injector.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {

  // Hive
  var box = await Hive.openBox('documents_box');
  sl.registerLazySingleton(() => box);

  // Check Connectivity
  sl.registerLazySingleton(() => ConnectivityService());
  sl<ConnectivityService>().initialize();

  // HTTP
  sl.registerLazySingleton(() => http.Client());

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(sendMessage: sl(), chatHistory: sl()),
  );
  sl.registerFactory<DocumentBloc>(
    () => DocumentBloc(
      getDocuments: sl(),
      getDetailDocument: sl(),
      deleteDocument: sl(),
      uploadDocument: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton<GetDocuments>(
    () => GetDocuments(documentRepository: sl()),
  );
  sl.registerLazySingleton<GetDetailDocument>(
    () => GetDetailDocument(documentRepository: sl()),
  );
  sl.registerLazySingleton<DeleteDocument>(
    () => DeleteDocument(documentRepository: sl()),
  );
  sl.registerLazySingleton<UploadDocument>(
    () => UploadDocument(documentRepository: sl()),
  );

  sl.registerLazySingleton<SendMessage>(
    () => SendMessage(chatRepository: sl()),
  );
  sl.registerLazySingleton<ChatHistory>(
    () => ChatHistory(chatRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(
      localDataSources: sl(),
      remoteDataSources: sl(),
      box: sl(),
    ),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSources: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // DataSources
  sl.registerLazySingleton<DocumentRemoteDataSources>(
    () => DocumentRemoteDataSourcesImpl(client: sl()),
  );
  sl.registerLazySingleton<DocumentLocalDataSources>(
    () => DocumentLocalDataSourcesImpl(box: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSources>(
    () => ChatRemoteDataSourcesImpl(client: sl()),
  );
}
