import 'dart:io';

import 'package:corp_doc_ai/core/error/exception.dart';
import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/document/data/datasources/remote_datasource.dart';
import 'package:corp_doc_ai/features/document/data/models/document_model.dart';
import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
// import 'package:corp_doc_ai/features/document/data/datasources/local_datasource.dart';
import 'package:corp_doc_ai/features/document/domain/repositories/document_repository.dart';
import 'package:dartz/dartz.dart';
// import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class DocumentRepositoryImpl extends DocumentRepository {
  final DocumentRemoteDataSources remoteDataSources;
  // final DocumentLocalDataSources localDataSources;
  // final Box box;

  DocumentRepositoryImpl({required this.remoteDataSources});

  @override
  Future<Either<Failure, List<DocumentEntity>>> getDocuments() async {
    bool checkConnection = await InternetConnection().hasInternetAccess;

    try {
      if (checkConnection) {
        List<DocumentModel> result = await remoteDataSources.getDocuments();
        // box.put('getDocuments', result);
        return Right(result.map((doc) => doc.toEntity()).toList());
      } else {
        // List<DocumentModel> documents = box.get('getDocuments') ?? [];
        return Right([]);
      }
    } on GeneralException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DocumentEntity>> deleteDocument(
    String documentId,
  ) async {
    bool checkConnection = await InternetConnection().hasInternetAccess;

    try {
      if (checkConnection) {
        DocumentModel result = await remoteDataSources.deleteDocument(
          documentId,
        );
        return Right(result.toEntity());
      } else {
        return Left(Failure('No internet connection'));
      }
    } on GeneralException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, DocumentEntity>> getDetailDocument(String documentId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, DocumentEntity>> uploadDocument(File document) async {
    bool checkConnection = await InternetConnection().hasInternetAccess;

    try {
      if (checkConnection) {
        DocumentModel result = await remoteDataSources.uploadDocument(document);
        return Right(result.toEntity());
      } else {
        return Left(Failure('No internet connection'));
      }
    } on GeneralException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('An unexpected error occurred'));
    }
  }
}
