import 'package:corp_doc_ai/features/document/data/models/document_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void configureAdapter() {
  Hive.registerAdapter(DocumentModelAdapter());
}