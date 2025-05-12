import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final int id;
  final String code;
  final int translationCount;
  final int reviewedCount;

  const Language({
    required this.id,
    required this.code,
    required this.translationCount,
    required this.reviewedCount,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      code: json['code'],
      translationCount: json['translation_count'],
      reviewedCount: json['reviewed_count']
    );
  }

  @override
  List<Object?> get props => [
    id,
    code,
    translationCount,
    reviewedCount
  ];
}