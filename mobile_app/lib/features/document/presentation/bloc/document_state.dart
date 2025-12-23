part of 'document_bloc.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final DocumentEntity document;

  const DocumentLoaded({required this.document});
  @override
  List<Object> get props => [document];
}

// List Document
class ListDocumentLoaded extends DocumentState {
  final List<DocumentEntity> documents;

  const ListDocumentLoaded({required this.documents});
  @override
  List<Object> get props => [documents];
}

class ListDocumentError extends DocumentState {
  final String message;

  const ListDocumentError({required this.message});
  @override
  List<Object> get props => [message];
}

// Delete Document
class DeleteDocumentError extends DocumentState {
  final String message;

  const DeleteDocumentError({required this.message});
  @override
  List<Object> get props => [message];
}

// Upload Document
class UploadDocumentLoading extends DocumentState {}

class UploadedDocumentError extends DocumentState {
  final String message;

  const UploadedDocumentError({required this.message});
  @override
  List<Object> get props => [message];
}

class UploadedDocument extends DocumentState {
  final DocumentEntity document;

  const UploadedDocument({required this.document});
  @override
  List<Object> get props => [document];
}
