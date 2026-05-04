import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Light Theme
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFFEC4899); // Pink
  static const Color accent = Color(0xFF8B5CF6); // Violet
  
  // Brand Colors - Dark Theme (More vibrant)
  static const Color primaryDark = Color(0xFF818CF8); 
  static const Color secondaryDark = Color(0xFFF472B6);
  static const Color accentDark = Color(0xFFA78BFA);
  
  // Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  
  // Surface
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);
  
  // Text
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  // States
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Helper to get theme-aware colors
  static Color getPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? primaryDark : primary;
  }

  static Color getSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? secondaryDark : secondary;
  }

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFFB7185)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getDynamicPrimaryGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark 
          ? [primaryDark, accentDark] 
          : [primary, accent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getDynamicAccentGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark 
          ? [accentDark, secondaryDark] 
          : [accent, secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
