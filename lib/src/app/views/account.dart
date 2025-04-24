import 'package:flutter/material.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/src/domain/model/user_model.dart';

class AccountScreen extends StatelessWidget {
  final User profile;

  const AccountScreen({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Account',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  AppIconButton(icon: Icons.edit_rounded, onPressed: () {}),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: _AccountForm(profile: profile,),
              ),
            ],
          ),
        ),
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
  final TextEditingController firstNameCtl = TextEditingController();
  final TextEditingController lastNameCtl = TextEditingController();
  final TextEditingController emailNameCtl = TextEditingController();

  bool showPassword = false;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? language;
  bool? format24h;
  DateFormat? dateFormat;

  @override
  void initState() {
    firstNameCtl.text = widget.profile.firstName ?? '';
    lastNameCtl.text = widget.profile.lastName ?? '';
    emailNameCtl.text = widget.profile.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
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
              SizedBox(
                width: 300,
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
            children: [
              SizedBox(
                width: 300,
                child: AppOutlinedTextField(
                  label: 'Email',
                  hint: 'Type your email',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'The email can\'t be empty.';
                    final RegExp regExp = RegExp(r"^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$");
                    if (!regExp.hasMatch(value)) return 'Enter a valid email.';
                    return null;
                  },
                  controller: emailNameCtl,
                ),
              ),
              SizedBox(width: 20,),
              SizedBox(
                width: 300,
                child: AppOutlinedTextField(
                  label: 'Password',
                  hint: 'Type your password',
                  validator: (value) {
                    if (value != null && value.isNotEmpty) password = value;
                    return null;
                  },
                  obscureText: !showPassword,
                  icon: IconButton(
                    onPressed: () => setState(() => showPassword = !showPassword),
                    icon: Icon(showPassword ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined)
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}