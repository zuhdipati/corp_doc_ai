part of 'document_bloc.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object> get props => [];
}

final class GetDocumentsEvent extends DocumentEvent {
  const GetDocumentsEvent();
}

final class GetDetailDocumentEvent extends DocumentEvent {
  const GetDetailDocumentEvent({required this.documentId});

  final String documentId;
}

final class DeleteDocumentEvent extends DocumentEvent {
  const DeleteDocumentEvent({required this.documentId});

  final String documentId;
}

final class UploadDocumentEvent extends DocumentEvent {
  const UploadDocumentEvent({required this.document});

  final DocumentEntity document;
}
