import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'package:corp_doc_ai/core/const/endpoints.dart';
import 'package:corp_doc_ai/core/error/exception.dart';
import 'package:corp_doc_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:corp_doc_ai/features/chat/data/models/chat_history_model.dart';
import 'package:corp_doc_ai/features/chat/data/models/chat_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDataSources {
  Future<ChatModel> sendMessage(String documentId, String message);
  Future<ChatHistoryModel> getChatHistory(
    String documentId, {
    int limit = 20,
    String? beforeId,
  });
}

class ChatRemoteDataSourcesImpl implements ChatRemoteDataSources {
  http.Client client;

  ChatRemoteDataSourcesImpl({required this.client});

  @override
  Future<ChatModel> sendMessage(String documentId, String message) async {
    final token = await AuthRepository().getIdToken();
    if (token == null) {
      throw GeneralException(message: 'Failed to authenticate user');
    }

    try {
      final url = Uri.parse(urlSendMessage);
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'document_id': documentId, 'message': message}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatModel.fromJson(data);
      } else {
        log('Send message failed: ${response.statusCode} - ${response.body}');
        throw GeneralException(message: 'Failed to send message');
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      log(e.toString());
      throw GeneralException(message: "An unexpected error occurred");
    }
  }

  @override
  Future<ChatHistoryModel> getChatHistory(
    String documentId, {
    int limit = 20,
    String? beforeId,
  }) async {
    final token = await AuthRepository().getIdToken();
    if (token == null) {
      throw GeneralException(message: 'Failed to authenticate user');
    }

    try {
      final url = Uri.parse(
        urlGetChatHistory(documentId, limit.toString(), beforeId ?? ''),
      );

      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(data.toString());
        final List<dynamic> messagesJson = data['messages'] ?? [];
        final messages = messagesJson
            .map((json) => ChatModel.fromJson(json))
            .toList();

        return ChatHistoryModel(
          messages: messages,
          hasMore: data['has_more'] ?? false,
          nextCursor: data['next_cursor'],
        );
      } else {
        log('Get history failed: ${response.statusCode} - ${response.body}');
        throw GeneralException(message: 'Failed to get chat history');
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      log(e.toString());
      throw GeneralException(message: "An unexpected error occurred");
    }
  }
}
