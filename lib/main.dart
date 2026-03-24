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
      title: "Tết Photo Booth",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        scaffoldBackgroundColor: const Color(0xFF8B0000),
        
        fontFamily: 'Serif',

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.yellow),
          titleTextStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 18, // GIẢM SIZE ĐỂ KHÔNG BỊ TRÀN
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),

        snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(
            fontFamily: 'Serif',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        dialogTheme: const DialogThemeData(
          titleTextStyle: TextStyle(
            fontFamily: 'Serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          contentTextStyle: TextStyle(
            fontFamily: 'Serif',
            fontSize: 14,
            color: Colors.black87,
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
