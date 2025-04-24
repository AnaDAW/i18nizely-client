import 'package:flutter/material.dart';

class AppOutlinedTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? icon;
  final TextEditingController? controller;

  const AppOutlinedTextField({super.key, required this.label, required this.hint, this.validator, this.obscureText = false, this.icon, this.controller});

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
        ),
      ],
    );
  }
}

class AppSearchTextField extends StatelessWidget {
  final String hint;

  const AppSearchTextField({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
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
        suffixIcon: Icon(Icons.search),
        suffixIconColor: Colors.black45
      ),
    );
  }
}