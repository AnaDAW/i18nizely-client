import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/translation_model.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';

class TransKey extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final User? createdBy;
  final List<Translation>? translations;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TransKey({
    this.id,
    this.name,
    this.description,
    this.image,
    this.createdBy,
    this.translations,
    this.createdAt,
    this.updatedAt
  });

  factory TransKey.fromJson(Map<String, dynamic> json) {
    List<Translation> translationList = [];
    if (json['translations'] != null) {
      for (Map<String, dynamic> translation in json['translations']) {
        translationList.add(Translation.fromJson(translation));
      }
    }

    return TransKey(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      createdBy: json['created_by'] != null ? User.fromJson(json['created_by']) : null,
      translations: translationList,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at'])
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    image,
    createdBy,
    createdAt,
    updatedAt
  ];

  Map<String, dynamic> toQueryMap() {
    Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    return map;
  }
}