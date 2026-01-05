part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final String? documentId;
  final List<ChatEntity> messages;
  final ChatStatus status;
  final bool isSending;
  final bool isLoadingHistory;
  final String? errorMessage;
  final bool hasMore;
  final String? nextCursor;

  const ChatState({
    this.documentId,
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.isSending = false,
    this.isLoadingHistory = false,
    this.errorMessage,
    this.hasMore = false,
    this.nextCursor,
  });

  ChatState copyWith({
    String? documentId,
    List<ChatEntity>? messages,
    ChatStatus? status,
    bool? isSending,
    bool? isLoadingHistory,
    String? errorMessage,
    bool? hasMore,
    String? nextCursor,
  }) {
    return ChatState(
      documentId: documentId ?? this.documentId,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      isSending: isSending ?? this.isSending,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  @override
  List<Object?> get props => [
    documentId,
    messages,
    status,
    isSending,
    isLoadingHistory,
    errorMessage,
    hasMore,
    nextCursor,
  ];
}
