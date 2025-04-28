import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taskify/providers/auth_provider.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/providers/theme_provider.dart';
import 'package:taskify/screens/splash_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Taskify',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6C63FF),
                brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
              scaffoldBackgroundColor: themeProvider.isDarkMode 
                ? const Color(0xFF121212) 
                : const Color(0xFFF8F9FA),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
