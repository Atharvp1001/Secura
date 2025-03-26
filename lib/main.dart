import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_screen.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'login_success_animation_screen.dart';
import 'dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://lsosdujqzjyebsyfwfru.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxzb3NkdWpxemp5ZWJzeWZ3ZnJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY0MTI2NjMsImV4cCI6MjA1MTk4ODY2M30.HkWxZAkgbYaUL3Bs_EaH9-qu3yLj-VlMN61dbS-RNJ0', // Replace with your public API key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secura App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Modern color palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4A90E2),
          primary: Color(0xFF4A90E2), // Primary color (blue)
          secondary: Color(0xFF50E3C2), // Accent color (greenish pastel)
          background: Color(0xFFF7F8FC), // Light background
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333), // Dark text
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            color: Color(0xFF555555),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4A90E2), // Button color
            foregroundColor: Colors.white, // Text color
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFF4A90E2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFFCCCCCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2.0),
          ),
          labelStyle: TextStyle(color: Color(0xFF4A90E2)),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/loginAnimation': (context) => LoginAnimationScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
