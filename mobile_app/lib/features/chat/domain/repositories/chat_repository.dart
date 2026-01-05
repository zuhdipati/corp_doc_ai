import 'package:corp_doc_ai/features/chat/domain/entities/chat_entity.dart';
import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_history_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatEntity>> sendMessage(
    String documentId,
    String message,
  );
  Future<Either<Failure, ChatHistoryEntity>> getChatHistory(String documentId);
}
