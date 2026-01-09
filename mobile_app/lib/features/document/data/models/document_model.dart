import 'package:corp_doc_ai/features/document/domain/entities/document_entity.dart';
import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 0)
class DocumentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fileName;

  @HiveField(2)
  final String fileType;

  @HiveField(3)
  final int sizeBytes;

  @HiveField(4)
  final DateTime uploadedAt;

  @HiveField(5)
  final String message;

  DocumentModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.sizeBytes,
    required this.uploadedAt,
    required this.message,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['document_id'] ?? '',
      fileName: json['file_name'] ?? '',
      fileType: json['file_type'] ?? '',
      sizeBytes: (json['size_bytes'])?.toInt() ?? 0,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : DateTime.now(),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': id,
      'file_name': fileName,
      'file_type': fileType,
      'size_bytes': sizeBytes,
      'uploaded_at': uploadedAt.toIso8601String(),
      'message': message,
    };
  }

  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      name: fileName,
      path: fileName,
      fileType: fileType,
    );
  }
}
