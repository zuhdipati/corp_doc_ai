import 'package:equatable/equatable.dart';

class DocumentEntity extends Equatable {
  final String id;
  final String name;
  final String path;
  final String fileType;

  const DocumentEntity({
    this.id = '',
    required this.name,
    required this.path,
    required this.fileType,
  });

  @override
  List<Object> get props => [id, name, path, fileType];
}