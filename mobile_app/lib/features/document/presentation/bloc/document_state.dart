part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class ListDocumentLoaded extends DocumentState {
  final List<DocumentEntity> documents;

  const ListDocumentLoaded({required this.documents});
  @override
  List<Object> get props => [documents];
}

class DocumentError extends DocumentState {
  final String message;

  const DocumentError({required this.message});
  @override
  List<Object> get props => [message];
}

class DocumentLoaded extends DocumentState {
  final DocumentEntity document;

  const DocumentLoaded({required this.document});
  @override
  List<Object> get props => [document];
}
