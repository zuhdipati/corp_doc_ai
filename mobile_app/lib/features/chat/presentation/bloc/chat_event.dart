part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String documentId;
  final String message;

  const SendMessageEvent({required this.documentId, required this.message});

  @override
  List<Object> get props => [documentId, message];
}

class GetHistoryEvent extends ChatEvent {
  final String documentId;

  const GetHistoryEvent({required this.documentId});

  @override
  List<Object> get props => [documentId];
}

class ClearChatEvent extends ChatEvent {}