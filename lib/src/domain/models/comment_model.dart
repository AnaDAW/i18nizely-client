import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class Comment extends Equatable {
  final int? id;
  final String? text;
  final User? createdBy;
  final DateTime? createdAt;

  const Comment({
    this.id,
    this.text,
    this.createdBy,
    this.createdAt
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
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

  Map<String, dynamic> toQueryMap() {
    return { 'text': text };
  }
}