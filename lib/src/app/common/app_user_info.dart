import 'package:flutter/material.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';

class AppUserInfo extends StatelessWidget {
  final String? image;
  final String initials;
  final String name;
  final String date;
  final bool invert;

  const AppUserInfo({super.key, required this.image, required this.initials, required this.name, required this.date, this.invert = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: invert ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        invert ? buildUserInfo() : buildUserIcon(),
        SizedBox(width: 5,),
        invert ? buildUserIcon() : buildUserInfo(),
      ],
    );
  }

  Widget buildUserIcon() {
    return SizedBox(
      height: 30,
      width: 30,
      child: AppUserIcon(
        image: image,
        userName: initials,
      ),
    );
  }

  Widget buildUserInfo() {
    return Column(
      crossAxisAlignment: invert ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
        Text(
          date,
          style: TextStyle(color: Colors.black45, fontSize: 12),
        ),
      ],
    );
  }
}