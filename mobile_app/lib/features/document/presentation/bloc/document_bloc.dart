import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/delete_document.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/get_detail_document.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/get_documents.dart';
import 'package:corp_doc_ai/features/document/domain/usecases/upload_document.dart';
import 'package:equatable/equatable.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  GetDocuments getDocuments;
  GetDetailDocument getDetailDocument;
  DeleteDocument deleteDocument;
  UploadDocument uploadDocument;

  DocumentBloc({
    required this.getDocuments,
    required this.getDetailDocument,
    required this.deleteDocument,
    required this.uploadDocument,
  }) : super(DocumentInitial()) {
    on<GetDocumentsEvent>(_onGetDocument);
    on<GetDetailDocumentEvent>(_onGetDetailDocument);
    on<DeleteDocumentEvent>(_onDeleteDocument);
    on<UploadDocumentEvent>(_onUploadDocument);
  }

  FutureOr<void> _onGetDocument(
    GetDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    final result = await getDocuments.call();
    result.fold(
      (l) => emit(DocumentError(message: l.message)),
      (r) => emit(ListDocumentLoaded(documents: r)),
    );
  }

  FutureOr<void> _onGetDetailDocument(
    GetDetailDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    final result = await getDetailDocument.call(event.documentId);
    result.fold(
      (l) => emit(DocumentError(message: l.message)),
      (r) => emit(DocumentLoaded(document: r)),
    );
  }

  FutureOr<void> _onDeleteDocument(
    DeleteDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    final result = await deleteDocument.call(event.documentId);
    result.fold(
      (l) => emit(DocumentError(message: l.message)),
      (r) => emit(DocumentLoaded(document: r)),
    );
  }

  FutureOr<void> _onUploadDocument(
    UploadDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    final result = await uploadDocument.call(event.document);
    result.fold(
      (l) => emit(DocumentError(message: l.message)),
      (r) => emit(DocumentLoaded(document: r)),
    );
  }
}
