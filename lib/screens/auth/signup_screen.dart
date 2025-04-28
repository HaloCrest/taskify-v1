import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taskify/providers/auth_provider.dart';
import 'package:taskify/screens/home/home_screen.dart';
import 'package:taskify/widgets/custom_button.dart';
import 'package:taskify/widgets/custom_text_field.dart';
import 'package:taskify/widgets/password_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.signup(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (success) {
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to create account. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo and Title
                  Text(
                    'Create Account',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ).animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0, duration: 500.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Join Taskify to organize your tasks',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ).animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 32),
                  
                  // Signup Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          focusNode: _nameFocusNode,
                          onEditingComplete: () => _emailFocusNode.requestFocus(),
                          textInputAction: TextInputAction.next,
                        ).animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 500.ms),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Email',
                          hintText: 'Enter your email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          focusNode: _emailFocusNode,
                          onEditingComplete: () => _passwordFocusNode.requestFocus(),
                          textInputAction: TextInputAction.next,
                        ).animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, delay: 400.ms, duration: 500.ms),
                        const SizedBox(height: 16),
                        PasswordField(
                          label: 'Password',
                          hintText: 'Create a password',
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          focusNode: _passwordFocusNode,
                          onEditingComplete: () => _confirmPasswordFocusNode.requestFocus(),
                          textInputAction: TextInputAction.next,
                        ).animate()
                          .fadeIn(delay: 500.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, delay: 500.ms, duration: 500.ms),
                        const SizedBox(height: 16),
                        PasswordField(
                          label: 'Confirm Password',
                          hintText: 'Confirm your password',
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          focusNode: _confirmPasswordFocusNode,
                          onEditingComplete: _signup,
                          textInputAction: TextInputAction.done,
                        ).animate()
                          .fadeIn(delay: 600.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, delay: 600.ms, duration: 500.ms),
                        
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.error.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: colorScheme.error,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ).animate()
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: -0.1, end: 0, duration: 300.ms),
                        ],
                        
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Create Account',
                          onPressed: _signup,
                          isLoading: _isLoading,
                          height: 56,
                        ).animate()
                          .fadeIn(delay: 700.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, delay: 700.ms, duration: 500.ms),
                        
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                              ),
                            ),
                          ],
                        ).animate()
                          .fadeIn(delay: 800.ms, duration: 500.ms),
                        
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: isSmallScreen ? '' : 'Continue with Google',
                                icon: FontAwesomeIcons.google,
                                onPressed: () {},
                                type: ButtonType.outline,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomButton(
                                text: isSmallScreen ? '' : 'Continue with Apple',
                                icon: FontAwesomeIcons.apple,
                                onPressed: () {},
                                type: ButtonType.outline,
                              ),
                            ),
                          ],
                        ).animate()
                          .fadeIn(delay: 900.ms, duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, delay: 900.ms, duration: 500.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
