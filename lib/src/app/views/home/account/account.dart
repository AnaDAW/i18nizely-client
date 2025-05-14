import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/config/app_config.dart';
import 'package:i18nizely/shared/domain/models/date_utils.dart';
import 'package:i18nizely/shared/widgets/app_cards.dart';
import 'package:i18nizely/src/app/common/app_confirmation_dialog.dart';
import 'package:i18nizely/src/app/common/app_title_bar.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_bloc.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_event.dart';
import 'package:i18nizely/src/app/views/home/account/bloc/profile_state.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/app/views/home/notifications/notifications.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class AccountScreen extends StatelessWidget {

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User profile = context.select((ProfileBloc bloc) {
      if (bloc.state is ProfileLoaded) {
        return (bloc.state as ProfileLoaded).profile;
      }
      return User();
    });

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitleBar(title: 'Account Settings',),
            Expanded(child: _AccountForm(profile: profile,),),
          ],
        ),
        NotificationsTab(),
      ],
    );
  }
}

class _AccountForm extends StatefulWidget {
  final User profile;

  const _AccountForm({required this.profile});

  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordCtl = TextEditingController();

  final Map<String, dynamic> languages= AppConfig.languages;
  bool showPassword = false;
  late String firstName;
  late String lastName;
  late String email;
  late String language;
  late bool format24h;
  late UserDateFormat dateFormat;

  @override
  void initState() {
    firstName = widget.profile.firstName ?? '';
    lastName = widget.profile.lastName ?? '';
    email = widget.profile.email ?? '';
    language = widget.profile.language ?? 'en';
    format24h = widget.profile.format24h ?? true;
    dateFormat = widget.profile.dateFormat ?? UserDateFormat.dmy;
    super.initState();
  }

  @override
  void dispose() {
    passwordCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, bottom: 20, right: 50, top: 50,),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(
                          height: 200,
                          width: 200,
                          child: AppUserIcon(
                            image: widget.profile.image,
                            userName: widget.profile.initials,
                          )
                      ),
                      AppIconButton(icon: Icons.edit_rounded, onPressed: () async {
                        final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          locator<ProfileBloc>().add(ChangeProfileImage(file.path));
                        }
                      }),
                      if (widget.profile.image != null && widget.profile.image!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 145, bottom: 7),
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: AppIconButton(icon: Icons.delete, primary: false, onPressed: () {
                              locator<ProfileBloc>().add(DeleteProfileImage());
                            }),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 50,),
                  Expanded(
                    child: Column(
                      children: [
                        AppElevatedCard(
                          padding: EdgeInsets.all(40),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AppOutlinedTextField(
                                        label: 'First Name',
                                        hint: 'Type your first name',
                                        initialValue: firstName,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return 'The first name can\'t be empty.';
                                          firstName = value;
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: AppOutlinedTextField(
                                        label: 'Last Name',
                                        hint: 'Type your last name',
                                        initialValue: lastName,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return 'The last name can\'t be empty.';
                                          lastName = value;
                                          return null;
                                        },
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
                                        initialValue: email,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) return 'The email can\'t be empty.';
                                          final RegExp regExp = RegExp(r"^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$");
                                          if (!regExp.hasMatch(value)) return 'Enter a valid email.';
                                          email = value;
                                          return null;
                                        },
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
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
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
                                      DropdownMenuItem(value: UserDateFormat.dmy, child: Text('DD/MM/YYYY')),
                                      DropdownMenuItem(value: UserDateFormat.mdy, child: Text('MM/DD/YYYY')),
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(color: AppColors.detail, indent: 25, endIndent: 25,),
        Padding(
          padding: const EdgeInsets.only(left: 50, bottom: 50, right: 50, top: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDate('Created at: ${widget.profile.createdAt?.toFormatStringDate(context) ?? 'Unknown Date'}'),
                  buildDate('Last update: ${widget.profile.updatedAt?.toFormatStringDate(context) ?? 'Unknown Date'}'),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 200,
                child: AppOutlinedButton(
                  text: 'Delete',
                  primary: true,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppConfirmationDialog(
                          title: 'Delete Profile',
                          description: 'Are you sure you want to delete your profile?',
                          button: 'Delete',
                          onPressed: () async {
                            locator<ProfileBloc>().add(DeleteProfile());
                            context.pop();
                          },
                        ),
                    );
                  },
                ),
              ),
              SizedBox(width: 20,),
              SizedBox(
                width: 200,
                child: AppStyledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
          
                    final User updatedUser = getUpdatedUser();
                    if (updatedUser == User()) return;
          
                    locator<ProfileBloc>().add(UpdateProfile(
                      newProfile: updatedUser,
                      password: passwordCtl.text.isNotEmpty ? passwordCtl.text : null
                    ));
                  },
                  text: 'Save',
                ),
              ),
            ]
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

  User getUpdatedUser() {
    return User(
      email: widget.profile.email != email ? email : null,
      firstName: widget.profile.firstName != firstName ? firstName : null,
      lastName: widget.profile.lastName != lastName ? lastName : null,
      language: widget.profile.language != language ? language : null,
      format24h: widget.profile.format24h != format24h ? format24h : null,
      dateFormat: widget.profile.dateFormat != dateFormat ? dateFormat : null,
    );
  }
}