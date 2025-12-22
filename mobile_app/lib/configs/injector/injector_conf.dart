import 'package:corp_doc_ai/core/services/connectivity_service.dart';
import 'package:corp_doc_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:corp_doc_ai/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:corp_doc_ai/features/document/data/datasources/local_datasource.dart';
import 'package:corp_doc_ai/features/document/data/datasources/remote_datasource.dart';
import 'package:corp_doc_ai/features/document/data/repositories/document_repository_impl.dart';
import 'package:corp_doc_ai/features/document/domain/repositories/document_repository.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/delete_document.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/get_detail_document.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/get_documents.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/upload_document.dart';
import 'package:corp_doc_ai/features/document/presentation/bloc/document_bloc.dart';
import 'package:get_it/get_it.dart';
// import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> initInjector() async {
   // Hive
  // var box = await Hive.openBox('documents_box');
  // sl.registerLazySingleton(
  //   () => box,
  // );

  // Check Connectivity
  sl.registerLazySingleton(() => ConnectivityService());
  sl<ConnectivityService>().initialize();

  // HTTP
  sl.registerLazySingleton(
    () => http.Client(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // BLoCs
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));

  // Document
  sl.registerFactory<DocumentBloc>(
    () => DocumentBloc(
      getDocuments: sl(),
      getDetailDocument: sl(),
      deleteDocument: sl(),
      uploadDocument: sl(),
    ),
  );

  // Document UseCases
  sl.registerLazySingleton<GetDocuments>(
    () => GetDocuments(documentRepository: sl())
  );
  sl.registerLazySingleton<GetDetailDocument>(
    () => GetDetailDocument(documentRepository: sl())
  );
  sl.registerLazySingleton<DeleteDocument>(
    () => DeleteDocument(documentRepository: sl())
  );
  sl.registerLazySingleton<UploadDocument>(
    () => UploadDocument(documentRepository: sl())
  );

  // Document Repository
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(
      // localDataSources: sl(),
      remoteDataSources: sl(),
      // box: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<DocumentRemoteDataSources>(
    () => DocumentRemoteDataSourcesImpl(client: sl()),
  );
  // sl.registerLazySingleton<DocumentLocalDataSources>(
  //   () => DocumentLocalDataSourcesImpl(box: sl()),
  // );  
}
