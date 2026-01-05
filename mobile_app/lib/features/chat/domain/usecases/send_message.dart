import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_entity.dart';
import 'package:corp_doc_ai/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class SendMessage {
  final ChatRepository chatRepository;

  SendMessage({required this.chatRepository});

  Future<Either<Failure, ChatEntity>> call(
    String documentId,
    String message,
  ) async {
    return await chatRepository.sendMessage(documentId, message);
  }
}
