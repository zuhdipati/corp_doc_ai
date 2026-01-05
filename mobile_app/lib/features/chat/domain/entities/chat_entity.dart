import 'package:equatable/equatable.dart';

enum ChatRole { user, bot }

class ChatEntity extends Equatable {
  final String id;
  final String message;
  final ChatRole role;
  final DateTime timestamp;

  const ChatEntity({
    required this.id,
    required this.message,
    required this.role,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, message, role, timestamp];
}
