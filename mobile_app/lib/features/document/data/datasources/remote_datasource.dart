import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:corp_doc_ai/core/const/endpoints.dart';
import 'package:corp_doc_ai/core/error/exception.dart';
import 'package:corp_doc_ai/features/auth/data/repositories/auth_repository.dart';
import 'package:corp_doc_ai/features/document/data/models/document_model.dart';
import 'package:http/http.dart' as http;

abstract class DocumentRemoteDataSources {
  Future<List<DocumentModel>> getDocuments();
  Future<DocumentModel> uploadDocument(File file);
  Future<DocumentModel> getDocumentDetail(String documentId);
  Future<DocumentModel> deleteDocument(String documentId);
}

class DocumentRemoteDataSourcesImpl implements DocumentRemoteDataSources {
  http.Client client;

  DocumentRemoteDataSourcesImpl({required this.client});

  @override
  Future<List<DocumentModel>> getDocuments() async {
    final token = await AuthRepository().getIdToken();
    if (token == null) {
      throw GeneralException(message: 'failed auth user');
    }

    try {
      final url = Uri.parse(urlGetDocuments);
      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = await json.decode(response.body);
        return List<DocumentModel>.from(
          data['documents'].map((x) => DocumentModel.fromJson(x)),
        );
      } else {
        throw GeneralException(message: 'Failed to load documents');
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      log(e.toString());
      throw GeneralException(message: "An unexpected error occurred");
    }
  }

  @override
  Future<DocumentModel> uploadDocument(File file) async {
    try {
      final url = Uri.parse(urlUploadDocuments);
      final response = await client
          .post(url, body: file)
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return DocumentModel.fromJson(data);
      } else {
        throw GeneralException(message: 'Failed to load documents');
      }
    } on TimeoutException {
      throw GeneralException(message: "Request timed out. Please try again.");
    } catch (e) {
      log(e.toString());
      throw GeneralException(message: "An unexpected error occurred");
    }
  }

  @override
  Future<DocumentModel> getDocumentDetail(String documentId) {
    throw UnimplementedError();
  }

  @override
  Future<DocumentModel> deleteDocument(String documentId) {
    throw UnimplementedError();
  }
}
