import 'package:corp_doc_ai/features/chat/data/models/chat_model.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_history_entity.dart';

class ChatHistoryModel {
  final List<ChatModel> messages;
  final bool hasMore;
  final String? nextCursor;

  ChatHistoryModel({
    required this.messages,
    required this.hasMore,
    this.nextCursor,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatHistoryModel(
        messages: List<ChatModel>.from(
          json['messages'].map((x) => ChatModel.fromJson(x)),
        ),
        hasMore: json['hasMore'],
        nextCursor: json['nextCursor'],
      );

  Map<String, dynamic> toJson() => {
    'messages': List<dynamic>.from(messages.map((x) => x.toJson())),
    'hasMore': hasMore,
    'nextCursor': nextCursor,
  };

  ChatHistoryEntity toEntity() => ChatHistoryEntity(
    messages: messages.map((x) => x.toEntity()).toList(),
    hasMore: hasMore,
    nextCursor: nextCursor,
  );
}
