import 'package:corp_doc_ai/features/document/data/models/document_model.dart';
import 'package:hive/hive.dart';

abstract class DocumentLocalDataSources {
  Future<List<DocumentModel>> getDocuments();
}

class DocumentLocalDataSourcesImpl implements DocumentLocalDataSources {
  final Box box;

  DocumentLocalDataSourcesImpl({required this.box});

  @override
  Future<List<DocumentModel>> getDocuments() async {
    List<dynamic> documents = box.get('documents_box') ?? [];
    if (documents.isEmpty) return [];
    return documents.cast<DocumentModel>();
  }
}
