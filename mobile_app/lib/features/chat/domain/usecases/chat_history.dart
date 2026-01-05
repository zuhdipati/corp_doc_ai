import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_history_entity.dart';
import 'package:corp_doc_ai/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ChatHistory {
  final ChatRepository chatRepository;

  ChatHistory({required this.chatRepository});

  Future<Either<Failure, ChatHistoryEntity>> call(String documentId) async {
    return await chatRepository.getChatHistory(documentId);
  }
}
