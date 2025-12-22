import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
import 'package:corp_doc_ai/features/document/domain/repositories/document_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteDocument {
  DocumentRepository documentRepository;

  DeleteDocument({required this.documentRepository});

  Future<Either<Failure, DocumentEntity>> call(String documentId) async {
    return await documentRepository.deleteDocument(documentId);
  }
}