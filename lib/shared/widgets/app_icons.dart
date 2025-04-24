import 'package:flutter/material.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';

class AppUserIcon extends StatelessWidget {
  final String? image;
  final String userName;

  const AppUserIcon({this.image, this.userName = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
        border: Border.all(width: 1, color: AppColors.detail,),
      ),
      child: Center(
        child: image != null && image!.isNotEmpty ? Image.network(image!) :
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(userName, style: TextStyle(fontSize: 100),),
          ),
        ),
      ),
    );
  }
  
}