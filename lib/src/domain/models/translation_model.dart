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
      isReviewed: json['isReviewed'],
      reviewedBy: json['reviewedBy'] != null ? User.fromJson(json['reviewedBy']) : null,
      reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt']) : null,
      createdBy: json['createdBy'] != null ? User.fromJson(json['createdBy']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt'])
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