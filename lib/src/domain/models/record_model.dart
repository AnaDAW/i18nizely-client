import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

enum RecordType { createKey, deleteKey, editKey, importKeys, editTranslation, reviewTranslation }

class Record extends Equatable {
  final int id;
  final RecordType type;
  final User? user;
  final DateTime createdAt;

  const Record({
    required this.id,
    required this.type,
    this.user,
    required this.createdAt
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      type: json['type'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: DateTime.parse(json['created_at'])
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    user,
    createdAt
  ];
}