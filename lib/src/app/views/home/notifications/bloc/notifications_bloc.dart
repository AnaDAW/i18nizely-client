import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_event.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_state.dart';
import 'package:i18nizely/src/domain/models/notification_model.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final UserApi userApi;

  NotificationsBloc(this.userApi) : super(const NotificationsInitial()) {
    on<GetNotifications>(_onGetNotifications);
    on<DeleteNotification>(_onDeleteNotification);
    on<ResetNotifications>(_onResetNotifications);
  }

  Future<void> _onGetNotifications(GetNotifications event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsLoading());
    try {
      final res = await userApi.getNotifications();
      res.fold((left) {
        emit(NotificationError(left.data));
      }, (right) {
        emit(NotificationLoaded(right));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onDeleteNotification(DeleteNotification event, Emitter<NotificationsState> emit) async {
    if (state is! NotificationLoaded) return;
    NotificationLoaded loadedState = state as NotificationLoaded;
    try {
      final res = await userApi.deleteNotification(id: event.id);
      await res.fold((left) {
        emit(NotificationDeleteError(loadedState.notifications, data: left.data));
      }, (right) async {
        final List<AppNotification> notifications = List.of(loadedState.notifications);
        notifications.removeWhere((notification) => notification.id == event.id);
        emit(NotificationDeleted(notifications));
        //await _onGetNotifications(GetNotifications(), emit);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(NotificationDeleteError(loadedState.notifications, data: e.toString()));
    }
  }

  Future<void> _onResetNotifications(ResetNotifications event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsInitial());
  }
}