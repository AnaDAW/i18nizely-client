import 'package:equatable/equatable.dart';

class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetNotifications extends NotificationsEvent {
  const GetNotifications();
}

class DeleteNotification extends NotificationsEvent {
  final int id;

  const DeleteNotification(this.id);
}

class ResetNotifications extends NotificationsEvent {
  const ResetNotifications();
}