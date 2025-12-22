import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DocumentRepository {
  Future<Either<Failure, List<DocumentEntity>>> getDocuments();
  Future<Either<Failure, DocumentEntity>> getDetailDocument(String documentId);
  Future<Either<Failure, DocumentEntity>> uploadDocument(DocumentEntity document);
  Future<Either<Failure, DocumentEntity>> deleteDocument(String documentId);
}