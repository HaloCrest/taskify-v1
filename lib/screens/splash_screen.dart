import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:taskify/providers/auth_provider.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: colorScheme.primary,
            ).animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
            const SizedBox(height: 24),
            Text(
              'Taskify',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ).animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 500.ms),
            const SizedBox(height: 8),
            Text(
              'Organize your tasks with ease',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ).animate()
              .fadeIn(delay: 500.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0, delay: 500.ms, duration: 500.ms),
            const SizedBox(height: 48),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ).animate()
              .fadeIn(delay: 800.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
