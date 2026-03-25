import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/editor_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EditorProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tết Bính Ngọ 2026",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000),
          primary: const Color(0xFFB71C1C),
          secondary: const Color(0xFFE6A317), 
        ),
        scaffoldBackgroundColor: const Color(0xFF640D14), // Đỏ đô thẫm
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFFFFD700)),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
            letterSpacing: 1.2,
          ),
        ),

        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF4A0404),
          contentTextStyle: TextStyle(
            fontFamily: 'Serif',
            fontSize: 15,
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
          behavior: SnackBarBehavior.floating,
        ),

        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFFFFFDE7),
          titleTextStyle: TextStyle(
            fontFamily: 'Serif',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB71C1C),
          ),
        ),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return auth.isLoggedIn ? HomePage() : const LoginScreen();
        },
      ),
    );
  }
}
