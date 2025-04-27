import 'package:flutter/material.dart';
import 'package:i18nizely/shared/widgets/app_icons.dart';

class AppOutlinedTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? icon;
  final TextEditingController? controller;
  final void Function(String)? onSubmit;
  final int maxLines;

  const AppOutlinedTextField({
    super.key, required this.label, this.initialValue, required this.hint, this.validator, this.obscureText = false,
    this.icon, this.controller, this.onSubmit, this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold,),
          ),
        ),
        SizedBox(height: 10,),
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black45),
            suffixIcon: icon,
          ),
          obscureText: obscureText,
          onFieldSubmitted: onSubmit,
          maxLines: maxLines,
        ),
      ],
    );
  }
}

class AppSearchTextField extends StatelessWidget {
  final String hint;
  final void Function(String) onSubmit;

  const AppSearchTextField({super.key, required this.hint, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    String text = '';

    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 25),
        fillColor: Colors.black12,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        suffixIcon: SizedBox(
          width: 45,
          height: 45,
          child: AppIconButton(icon: Icons.search_rounded, onPressed: () => onSubmit(text), primary: false,)
        ),
        suffixIconColor: Colors.black45,
      ),
      onSubmitted: onSubmit,
      onChanged: (value) => text = value,
    );
  }
}