import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:i18nizely/src/app/views/home.dart';
import 'package:intl/intl.dart' as i;
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:i18nizely/src/domain/services/user_api.dart';

class AccountScreen extends StatelessWidget {

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10,),
            ],
          ),
          child: Text(
            'Account Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(70),
            child: _AccountForm(),
          ),
        ),
      ],
    );
  }
}

class _AccountForm extends StatefulWidget {

  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameCtl = TextEditingController();
  final TextEditingController lastNameCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();

  Map<String, dynamic> languages = {};
  bool showPassword = false;
  late User profile;
  late String firstName;
  late String lastName;
  late String email;
  late String language;
  late bool format24h;
  late DateFormat dateFormat;

  @override
  void initState() {
    getLanguages();
    getProfile();

    firstName = profile.firstName ?? '';
    lastName = profile.lastName ?? '';
    email = profile.email ?? '';
    language = profile.language ?? 'en';
    format24h = profile.format24h ?? true;
    dateFormat = profile.dateFormat ?? DateFormat.dmy;

    firstNameCtl.text = firstName;
    lastNameCtl.text = lastName;
    emailCtl.text = email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    SizedBox(
                        height: 200,
                        width: 200,
                        child: AppUserIcon(
                          image: profile.image,
                          userName: '${profile.firstName?[0]}${profile.lastName?[0]}',
                        )
                    ),
                    AppIconButton(icon: Icons.edit_rounded, onPressed: () {
                      //locator<UserApi>().changeProfileImage(pathImage: '');
                    }),
                  ],
                ),
                SizedBox(height: 40,),
                buildDate('Created at: ${formatDate(profile.createdAt)}'),
                buildDate('Last update: ${formatDate(profile.updatedAt)}'),
              ],
            ),
            SizedBox(width: 50,),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppOutlinedTextField(
                            label: 'First Name',
                            hint: 'Type your first name',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'The first name can\'t be empty.';
                              firstName = value;
                              return null;
                            },
                            controller: firstNameCtl,
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: AppOutlinedTextField(
                            label: 'Last Name',
                            hint: 'Type your last name',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'The last name can\'t be empty.';
                              lastName = value;
                              return null;
                            },
                            controller: lastNameCtl,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppOutlinedTextField(
                            label: 'Email',
                            hint: 'Type your email',
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'The email can\'t be empty.';
                              final RegExp regExp = RegExp(r"^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$");
                              if (!regExp.hasMatch(value)) return 'Enter a valid email.';
                              email = value;
                              return null;
                            },
                            controller: emailCtl,
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: AppOutlinedTextField(
                            label: 'Password',
                            hint: 'Type your password',
                            obscureText: !showPassword,
                            icon: IconButton(
                              onPressed: () => setState(() => showPassword = !showPassword),
                              icon: Icon(showPassword ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined),
                            ),
                            controller: passwordCtl,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Divider(
                      color: AppColors.detail,
                      thickness: 1,
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time Format', style: TextStyle(fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Checkbox(
                                  value: format24h,
                                  onChanged: (value) => setState(() => format24h = value!),
                                ),
                                Text('24h',),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date Format', style: TextStyle(fontWeight: FontWeight.bold),),
                            DropdownButton(
                              value: dateFormat,
                              items: [
                                DropdownMenuItem(value: DateFormat.dmy, child: Text('DD/MM/YYYY')),
                                DropdownMenuItem(value: DateFormat.mdy, child: Text('MM/DD/YYYY')),
                              ],
                              onChanged: (value) => setState(() => dateFormat = value!),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Language', style: TextStyle(fontWeight: FontWeight.bold),),
                            DropdownButton(
                              value: language,
                              items: [
                                for (MapEntry<String, dynamic> entry in languages.entries)
                                  DropdownMenuItem(value: entry.key, child: Text(entry.value as String))
                              ],
                              onChanged: (value) => setState(() => language = value!),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 200,
              child: AppStyledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final User updatedUser = getUpdatedUser();
                  if (updatedUser == User()) return;

                  final res = await locator<UserApi>().updateProfile(
                      newProfile: updatedUser,
                      password: passwordCtl.text.isNotEmpty ? passwordCtl.text : null
                  );
                  res.fold(
                    (left) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There have been a problem.')));
                    },
                        (right) {
                      setState(() => profile = right);
                      HomeScreen.setProfile(context, right);
                      passwordCtl.clear();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User updated.')));
                    }
                  );
                },
                text: 'Save',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDate(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black45,
        fontSize: 12,
      ),
    );
  }

  Future<void> getLanguages() async {
    String json = await DefaultAssetBundle.of(context).loadString('assets/languages.json');
    setState(() => languages = jsonDecode(json));
  }

  User getUpdatedUser() {
    return User(
      email: profile.email != email ? email : null,
      firstName: profile.firstName != firstName ? firstName : null,
      lastName: profile.lastName != lastName ? lastName : null,
      language: profile.language != language ? language : null,
      format24h: profile.format24h != format24h ? format24h : null,
      dateFormat: profile.dateFormat != dateFormat ? dateFormat : null,
    );
  }



  void getProfile() => profile = HomeScreen.getProfile(context) ?? User();

  String formatDate(DateTime? date) {
    final i.DateFormat dateFormatter = i.DateFormat(profile.dateFormat == DateFormat.dmy ? 'dd/MM/yyyy' : 'MM/dd/yyyy');

    if (profile.format24h == null || profile.format24h!) {
      dateFormatter.add_Hm();
    } else {
      dateFormatter.add_jm();
    }

    final Duration timeZoneOffset = DateTime.now().timeZoneOffset;
    return date != null ? dateFormatter.format(date.add(timeZoneOffset)) : 'Unknown';
  }
}