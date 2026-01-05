import 'dart:async';
import 'package:corp_doc_ai/features/chat/domain/usecases/chat_history.dart';
import 'package:corp_doc_ai/features/chat/domain/usecases/send_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:corp_doc_ai/features/chat/domain/entities/chat_entity.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  SendMessage sendMessage;
  ChatHistory chatHistory;

  ChatBloc({required this.sendMessage, required this.chatHistory})
    : super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<GetHistoryEvent>(_onGetHistory);
    on<ClearChatEvent>(_onClearChat);
  }

  FutureOr<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final userMessage = ChatEntity(
      id: '',
      message: event.message,
      role: ChatRole.user,
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        documentId: event.documentId,
        isSending: true,
        errorMessage: null,
        messages: [...state.messages, userMessage],
      ),
    );
    final result = await sendMessage.call(event.documentId, event.message);
    emit(
      result.fold(
        (l) => state.copyWith(isSending: false, errorMessage: l.message),
        (r) => state.copyWith(isSending: false, messages: [...state.messages, r]),
      ),
    );
  }

  FutureOr<void> _onGetHistory(
    GetHistoryEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        documentId: event.documentId,
        isLoadingHistory: true,
        errorMessage: null,
      ),
    );
    final result = await chatHistory.call(event.documentId);
    emit(
      result.fold(
        (l) => state.copyWith(isLoadingHistory: false, errorMessage: l.message),
        (r) => state.copyWith(
          isLoadingHistory: false,
          status: ChatStatus.success,
          messages: r.messages,
          hasMore: r.hasMore,
          nextCursor: r.nextCursor,
        ),
      ),
    );
  }

  FutureOr<void> _onClearChat(
    ClearChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState());
  }
}
