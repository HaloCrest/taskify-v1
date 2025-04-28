import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? lottieAsset;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null) ...[
              Lottie.asset(
                lottieAsset!,
                width: 200,
                height: 200,
                repeat: true,
              ),
            ] else ...[
              Icon(
                Icons.inbox_outlined,
                size: 80,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
            ],
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutQuad);
  }
}
