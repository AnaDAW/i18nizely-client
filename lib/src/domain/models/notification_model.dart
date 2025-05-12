import 'package:equatable/equatable.dart';

enum NotificationType { comment, invitation }

class AppNotification extends Equatable {
  final int id;
  final NotificationType type;
  final bool isRead;
  final int? commentId;
  final int projectId;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.isRead,
    this.commentId,
    required this.projectId,
    required this.createdAt
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: NotificationType.values[json['type'] - 1],
      isRead: json['is_read'],
      commentId: json['comment'],
      projectId: json['project'],
      createdAt: DateTime.parse(json['created_at'])
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    isRead,
    commentId,
    projectId,
    createdAt
  ];
}