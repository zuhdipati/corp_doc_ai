import 'package:corp_doc_ai/features/chat/domain/entities/chat_entity.dart';

class ChatModel {
  final String id;
  final String userId;
  final String documentId;
  final String message;
  final String role;
  final String timestamp;
  ChatModel({
    required this.id,
    required this.userId,
    required this.documentId,
    required this.message,
    required this.role,
    required this.timestamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['id'],
    userId: json['user_id'],
    documentId: json['document_id'],
    message: json['message'],
      role: json['role'],
    timestamp: json['timestamp'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'document_id': documentId,
    'message': message,
    'role': role,
    'timestamp': timestamp,
  };

  ChatEntity toEntity() => ChatEntity(
    id: id,
    message: message,
    role: ChatRole.values.firstWhere((e) => e.name == role),
    timestamp: DateTime.parse(timestamp),
  );
}
