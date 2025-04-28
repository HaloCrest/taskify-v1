import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: _isFocused 
                ? colorScheme.primary 
                : isDarkMode 
                    ? Colors.white70 
                    : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ).animate(target: _isFocused ? 1 : 0)
          .tint(color: colorScheme.primary, duration: 200.ms),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _hasError 
                    ? Colors.red.withOpacity(0.1) 
                    : Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            focusNode: _focusNode,
            onEditingComplete: widget.onEditingComplete,
            textInputAction: widget.textInputAction,
            autofocus: widget.autofocus,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white38 : Colors.black38,
              ),
              prefixIcon: widget.prefixIcon != null 
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused 
                          ? colorScheme.primary 
                          : isDarkMode 
                              ? Colors.white54 
                              : Colors.black54,
                    ) 
                  : null,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: isDarkMode 
                  ? Colors.grey[850] 
                  : Colors.grey[50],
              errorStyle: const TextStyle(height: 0),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode 
                      ? Colors.grey[700]! 
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              final error = widget.validator?.call(value);
              setState(() {
                _hasError = error != null;
                _errorText = error;
              });
              return error;
            },
          ),
        ),
        if (_errorText != null && _hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: colorScheme.error,
                fontSize: 12,
              ),
            ),
          ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0),
      ],
    );
  }
}
