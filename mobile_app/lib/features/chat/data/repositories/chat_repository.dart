import 'package:corp_doc_ai/core/error/exception.dart';
import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/chat/data/datasources/remote_datasource.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_history_entity.dart';
import 'package:corp_doc_ai/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_entity.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSources remoteDataSources;

  ChatRepositoryImpl({required this.remoteDataSources});

  @override
  Future<Either<Failure, ChatEntity>> sendMessage(
    String documentId,
    String message,
  ) async {
    bool checkConnection = await InternetConnection().hasInternetAccess;

    try {
      if (checkConnection) {
        final result = await remoteDataSources.sendMessage(documentId, message);
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
  Future<Either<Failure, ChatHistoryEntity>> getChatHistory(
    String documentId,
  ) async {
    bool checkConnection = await InternetConnection().hasInternetAccess;

    try {
      if (checkConnection) {
        final result = await remoteDataSources.getChatHistory(documentId);
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
