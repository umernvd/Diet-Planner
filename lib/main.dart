import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

// Custom app colors
class AppColors {
  // Primary green colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color darkGreen = Color(0xFF2E7D32);
  
  // Accent colors
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentBlue = Color(0xFF03A9F4);
  
  // Neutral colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet Planner',
      theme: ThemeData(
        // Updated vibrant color scheme
        colorScheme: ColorScheme(
          primary: AppColors.primaryGreen,
          secondary: AppColors.accentOrange,
          tertiary: AppColors.accentBlue,
          surface: AppColors.cardBackground,
          // Use surface instead of background
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textDark,
          // Use onSurface instead of onBackground
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Updated typography with Google Fonts
        textTheme: GoogleFonts.nunitoTextTheme(
          TextTheme(
            displayLarge: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            displayMedium: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            displaySmall: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            headlineMedium: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            titleLarge: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            bodyLarge: TextStyle(
              fontSize: 16, 
              color: AppColors.textDark,
            ),
            bodyMedium: TextStyle(
              fontSize: 14, 
              color: AppColors.textMedium,
            ),
          ),
        ),
        
        // Modernized card theme
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.cardBackground,
          surfaceTintColor: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.lightGreen.withAlpha(51), width: 1),
          ),
        ),
        
        // Updated app bar theme
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textDark,
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        
        // Modernized input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.lightGreen.withAlpha(77), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.lightGreen.withAlpha(77), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
          labelStyle: TextStyle(color: AppColors.textMedium),
          hintStyle: TextStyle(color: AppColors.textLight),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
