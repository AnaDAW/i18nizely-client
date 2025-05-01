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
    final DateFormat dateFormatter = DateFormat(profile.dateFormat == UserDateFormat.mdy ? 'MM/dd/yyyy' : 'dd/MM/yyyy');

    if (profile.format24h == false) {
      dateFormatter.add_jm();
    } else {
      dateFormatter.add_Hm();
    }

    final Duration timeZoneOffset = DateTime.now().timeZoneOffset;
    return dateFormatter.format(add(timeZoneOffset));
  }
}