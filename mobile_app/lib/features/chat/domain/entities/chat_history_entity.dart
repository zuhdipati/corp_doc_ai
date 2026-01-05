import 'package:corp_doc_ai/features/chat/domain/entities/chat_entity.dart';
import 'package:equatable/equatable.dart';

class ChatHistoryEntity extends Equatable {
  final List<ChatEntity> messages;
  final bool hasMore;
  final String? nextCursor;

  const ChatHistoryEntity({
    required this.messages,
    required this.hasMore,
    this.nextCursor,
  });

  @override
  List<Object?> get props => [messages, hasMore, nextCursor];
}