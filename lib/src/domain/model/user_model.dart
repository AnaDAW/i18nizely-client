import 'package:equatable/equatable.dart';

enum DateFormat { dmy, mdy }

class User extends Equatable {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? language;
  final bool? format24h;
  final DateFormat? dateFormat;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
    this.language,
    this.format24h,
    this.dateFormat,
    this.createdAt,
    this.updatedAt
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      image: json['image'],
      language: json['language'],
      format24h: json['format_24h'],
      dateFormat: json['date_format'] != null ? DateFormat.values[json['date_format'] - 1] : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    image,
    language,
    format24h,
    dateFormat,
    createdAt,
    updatedAt
  ];

  Map<String, dynamic> toQueryMap() {
    Map<String, dynamic> map = {};
    if (email != null) map['email'] = email;
    if (firstName != null) map['first_name'] = firstName;
    if (lastName != null) map['last_name'] = lastName;
    if (language != null) map['language'] = language;
    if (format24h != null) map['format_24h'] = format24h;
    if (dateFormat != null) map['date_format'] = dateFormat;
    return map;
  }
}