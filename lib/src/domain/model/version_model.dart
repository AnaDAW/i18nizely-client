import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';

class Version extends Equatable {
  final int id;
  final String text;
  final User? createdBy;
  final DateTime createdAt;

  const Version({
    required this.id,
    required this.text,
    required this.createdBy,
    required this.createdAt
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      id: json['id'],
      text: json['text'],
      createdBy: json['created_by'] != null ? User.fromJson(json['created_by']) : null,
      createdAt: DateTime.parse(json['created_at'])
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    createdBy,
    createdAt
  ];
}