import 'dart:io';

import 'package:corp_doc_ai/core/error/failure.dart';
import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
import 'package:corp_doc_ai/features/document/domain/repositories/document_repository.dart';
import 'package:dartz/dartz.dart';

class UploadDocument {
  DocumentRepository documentRepository;

  UploadDocument({required this.documentRepository});

  Future<Either<Failure, DocumentEntity>> call(File document) async {
    return await documentRepository.uploadDocument(document);
  }
}
