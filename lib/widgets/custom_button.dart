import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 50,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Define styles based on button type
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    switch (type) {
      case ButtonType.primary:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        borderColor = Colors.transparent;
        break;
      case ButtonType.secondary:
        backgroundColor = colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        borderColor = Colors.transparent;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        textColor = colorScheme.primary;
        borderColor = colorScheme.primary;
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = colorScheme.primary;
        borderColor = Colors.transparent;
        break;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          splashColor: textColor.withOpacity(0.1),
          highlightColor: textColor.withOpacity(0.05),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: type == ButtonType.outline ? 2 : 0,
              ),
              gradient: type == ButtonType.primary 
                ? LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withBlue(colorScheme.primary.blue + 20),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
              boxShadow: type == ButtonType.text || type == ButtonType.outline
                  ? null
                  : [
                      BoxShadow(
                        color: backgroundColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: textColor, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .scaleXY(begin: 0.95, end: 1, duration: 300.ms, curve: Curves.easeOut);
  }
}
