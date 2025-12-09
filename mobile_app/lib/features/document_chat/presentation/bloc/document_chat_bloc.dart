import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'document_chat_event.dart';
part 'document_chat_state.dart';

class DocumentChatBloc extends Bloc<DocumentChatEvent, DocumentChatState> {
  DocumentChatBloc() : super(DocumentChatInitial()) {
    on<DocumentChatEvent>((event, emit) {
      
    });
  }
}
