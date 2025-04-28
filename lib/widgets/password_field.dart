import 'package:flutter/material.dart';
import 'package:taskify/widgets/custom_text_field.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;

  const PasswordField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.validator,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
    );
  }
}
