import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SidebarMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;

  const SidebarMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
            ? colorScheme.primary.withOpacity(0.1) 
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: colorScheme.primary.withOpacity(0.1),
          highlightColor: colorScheme.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected 
                      ? colorScheme.primary 
                      : isDarkMode 
                          ? Colors.grey[400] 
                          : Colors.grey[700],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected 
                          ? colorScheme.primary 
                          : isDarkMode 
                              ? Colors.grey[300] 
                              : Colors.grey[800],
                    ),
                  ),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate(target: isSelected ? 1 : 0)
      .custom(
        duration: 200.ms,
        builder: (context, value, child) => Transform.scale(
          scale: 1.0 + (value * 0.02),
          child: child,
        ),
      );
  }
}
