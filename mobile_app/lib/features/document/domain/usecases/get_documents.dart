
import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
import 'package:corp_doc_ai/features/document/domain/repositories/document_repository.dart';
import 'package:dartz/dartz.dart';

class GetDocuments {
  final DocumentRepository documentRepository;

  GetDocuments({required this.documentRepository});

  Future<Either<Failure, List<DocumentEntity>>> call() async {
    return await documentRepository.getDocuments();
  }
}