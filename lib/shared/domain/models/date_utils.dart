import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:intl/intl.dart';

extension AppDateExtension on DateTime {
  String toFormatStringDate(BuildContext context) {
    final User profile = context.select((ProfileBloc bloc) {
      if (bloc.state is ProfileLoaded) {
        return (bloc.state as ProfileLoaded).profile;
      }
      return User();
    });

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    final DateTime dateTime = add(now.timeZoneOffset);
    final DateTime onlyDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    late final String date;
    late final String time;

    if (onlyDate == today) {
      date = 'Today';
    } else if (onlyDate == yesterday) {
      date = 'Yesterday';
    } else {
      date = DateFormat(profile.dateFormat == UserDateFormat.mdy ? 'MM/dd/yyyy' : 'dd/MM/yyyy').format(dateTime);
    }
    time = DateFormat(profile.format24h == false ? 'jm' : 'Hm').format(dateTime);
    
    return '$date $time';
  }
}