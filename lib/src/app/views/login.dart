import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i18nizely/shared/widgets/app_buttons.dart';
import 'package:i18nizely/shared/widgets/app_textfields.dart';
import 'package:i18nizely/shared/theme/app_colors.dart';
import 'package:i18nizely/src/di/dependency_injection.dart';
import 'package:i18nizely/src/domain/service/auth_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.secondary
                  ]
                ),
                borderRadius: BorderRadius.horizontal(right: Radius.circular(20),)
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(50.0),
              child: _LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  String invalidMsg = '';
  bool isLoggind = false;
  bool showPassword = false;

  @override
  void initState() {
    context.pushReplacement('/');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login To Your Account',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,),
          ),
          SizedBox(height: 75,),
          AppOutlinedTextField(label: 'Email', hint: 'Type your email', validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter the email';
            email = value;
            return null;
          }),
          SizedBox(height: 30,),
          AppOutlinedTextField(
            label: 'Password',
            hint: 'Type your password',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter the password';
              password = value;
              return null;
            },
            obscureText: !showPassword,
            icon: IconButton(
              onPressed: () => setState(() => showPassword = !showPassword),
              icon: Icon(showPassword ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined)
            ),
          ),
          SizedBox(height: 55,),
          Text(invalidMsg, style: TextStyle(color: Colors.red, fontSize: 12),),
          SizedBox(height: 5,),
          AppStyledButton(
            onPressed: () async {
              if (isLoggind) return;

              setState(() => invalidMsg = '');
              if (!_formKey.currentState!.validate()) return;

              isLoggind = true;
              if(await login(email, password)) {
                context.pushReplacement('/');
              } else {
                setState(() => invalidMsg = 'No active account found with the given credentials.');
              }

              isLoggind = false;
            },
            text: 'LOGIN',
          ),
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {},
              child: Text('Forgot the password?', style: TextStyle(color: AppColors.detail),),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> login(String email, String password) async {
    final res = await locator<AuthApi>().login(email: email, password: password);
    return res.fold((left) => false, (rigth) => true);
  }
}