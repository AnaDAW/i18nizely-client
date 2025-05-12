import 'package:flutter/material.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_bloc.dart';
import 'package:i18nizely/src/app/views/home/notifications/bloc/notifications_event.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';

class AppTitleBar extends StatelessWidget {
  final String title;
  final bool hasSearch;
  final String hint;
  final void Function(String?)? onSumitSearch;

  const AppTitleBar({super.key, required this.title, this.hasSearch = false, this.hint = '', this.onSumitSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: hasSearch ? 10: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10,),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          buildBar(),
          if (hasSearch)
            Center(
              child: SizedBox(
                width: 500,
                child: AppSearchTextField(
                  hint: hint,
                  onSubmit: (value) {
                    final name = value.isNotEmpty ? value : null;
                    if (onSumitSearch != null) onSumitSearch!(name);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
        ),
        IconButton(
          onPressed: () => locator<NotificationsBloc>().add(GetNotifications()),
          icon: Icon(Icons.notifications_none_rounded, color: Colors.black45,)
        ),
      ],
    );
  }
}