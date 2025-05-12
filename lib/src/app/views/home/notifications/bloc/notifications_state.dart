import 'package:equatable/equatable.dart';
import 'package:i18nizely/src/domain/models/notification_model.dart';

class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationLoaded extends NotificationsState {
  final List<AppNotification> notifications;

  const NotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationsState {
  final dynamic data;

  const NotificationError(this.data);

  @override
  List<Object?> get props => [data];
}

class NotificationDeleted extends NotificationLoaded {
  const NotificationDeleted(super.notifications);
}

class NotificationDeleteError extends NotificationLoaded {
  final dynamic data;

  const NotificationDeleteError(super.notifications, {required this.data});

  @override
  List<Object?> get props => [notifications, data];
}