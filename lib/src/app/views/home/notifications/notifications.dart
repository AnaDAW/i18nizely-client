import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_bloc.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_event.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_state.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_bloc.dart';
import 'package:i18nizely/src/app/views/home/project/bloc/project_event.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_bloc.dart';
import 'package:i18nizely/src/app/views/home/translations/bloc/translations_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/notification_model.dart';
import 'package:i18nizely/src/domain/services/project_api.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 55),
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsInitial) {
            return Container();
          } else if (state is NotificationsLoading) {
            return AppElevatedCard(
              child: SizedBox(
                width: 400,
                height: 400,
                child: Center(child: CircularProgressIndicator(color: AppColors.detail,),),
              ),
            );
          } else if (state is NotificationError) {
            return AppElevatedCard(
              child: SizedBox(
                width: 400,
                height: 400,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_rounded, color: Colors.red.shade400,),
                      SizedBox(width: 5,),
                      Text(
                        'Error getting the notifications.',
                        style: TextStyle(color: Colors.red.shade400),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return AppElevatedCard(
            padding: EdgeInsets.all(20),
            child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.detail,),);
                } else if (state is NotificationLoaded) {
                  return SizedBox(
                    width: 400,
                    height: 400,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            IconButton(
                              onPressed: () => locator<NotificationsBloc>().add(ResetNotifications()),
                              icon: Icon(Icons.close)
                            ),
                            Center(
                              child: Text(
                                'Notifications',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: AppColors.detail,),
                        Expanded(
                          child: state.notifications.isEmpty ? Center(
                            child: Text('No notifications yet.', style: TextStyle(color: Colors.black45,),),
                          ) : ListView.builder(
                            itemCount: state.notifications.length,
                            itemBuilder: (context, index) {
                              return _NotificationItem(notification: state.notifications.reversed.toList()[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }
            ),
          );
        }
      ),
    );
  }
}

class _NotificationItem extends StatefulWidget {
  final AppNotification notification;

  const _NotificationItem({required this.notification});

  @override
  State<_NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem> {
  String projectName = 'Unknown Project';

  @override
  void initState() {
    getProjectName(widget.notification.projectId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            locator<ProjectBloc>().add(GetProject(widget.notification.projectId));
            locator<TranslationsBloc>().add(GetTranslations(projectId: widget.notification.projectId, page: 1));
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You have been invited to $projectName',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontWeight: widget.notification.isRead ? FontWeight.normal : FontWeight.bold),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        widget.notification.createdAt.toFormatStringDate(context),
                        style: TextStyle(color: Colors.black45),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                IconButton(
                  onPressed: () => locator<NotificationsBloc>().add(DeleteNotification(widget.notification.id)),
                  icon: Icon(Icons.delete, color: Colors.red.shade400,)
                ),
              ],
            ),
          ),
        ),
        Divider(color: AppColors.detail,),
      ],
    );
  }

  Future<void> getProjectName(int id) async {
    var res = await locator<ProjectApi>().getProject(id: id);
    res.fold((left) {
      setState(() => projectName = 'Unknown Project');
    }, (right) {
      setState(() => projectName = right.name ?? 'Unknown Project');
    });
  }
}