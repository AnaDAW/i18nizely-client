import 'package:flutter/material.dart';

class AppSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(BuildContext context, {required String text, bool isError = false}) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.white,),),
          backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          behavior: SnackBarBehavior.floating,
          width: 300,
        )
    );
  }
}