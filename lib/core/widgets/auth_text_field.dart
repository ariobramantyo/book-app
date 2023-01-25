import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final Function(String?)? validator;
  final Function(String)? onChanged;
  final String? errorText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Function(String)? onActionDone;

  const AuthTextField(
      {super.key,
      this.controller,
      required this.label,
      required this.hint,
      this.obscure = false,
      this.suffixIcon,
      this.onChanged,
      this.validator,
      this.errorText,
      this.textInputAction,
      this.textInputType,
      this.onActionDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: TextFormField(
            controller: controller,
            onFieldSubmitted: onActionDone,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            obscureText: obscure,
            style: Theme.of(context).textTheme.subtitle2,
            onChanged: onChanged,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(bottom: 3),
                hintText: hint,
                errorText: errorText,
                suffixIconConstraints: const BoxConstraints(maxHeight: 20),
                suffixIcon: suffixIcon,
                hintStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            validator: (value) => validator!(value),
          ),
        ),
      ],
    );
  }
}
