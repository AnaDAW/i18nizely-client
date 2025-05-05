import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class Translation extends Equatable {
  final int? id;
  final String? text;
  final String? language;
  final bool? isReviewed;
  final User? reviewedBy;
  final DateTime? reviewedAt;
  final User? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Translation({
    this.id,
    this.text,
    this.language,
    this.isReviewed,
    this.reviewedBy,
    this.reviewedAt,
    this.createdBy,
    this.createdAt,
    this.updatedAt
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      text: json['text'],
      language: json['language'],
      isReviewed: json['is_reviewed'],
      reviewedBy: json['reviewed_by'] != null ? User.fromJson(json['reviewed_by']) : null,
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at']) : null,
      createdBy: json['created_by'] != null ? User.fromJson(json['created_by']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    language,
    isReviewed,
    reviewedBy,
    reviewedAt,
    createdBy,
    createdAt,
    updatedAt
  ];

  Map<String, dynamic> toQueryMap() {
    Map<String, dynamic> map = {};
    if (text != null) map['text'] = text;
    if (language != null) map['language'] = language;
    return map;
  }
}