import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core Blue Palette - Modern and vibrant
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Blue
  static const Color accentBlue = Color(0xFF3B82F6); // Vibrant Blue
  static const Color lightBlue = Color(0xFF60A5FA); // Light Blue
  static const Color softBlue = Color(0xFFDBEAFE); // Very Light Blue
  static const Color darkBlue = Color(0xFF1E293B); // Dark Navy

  // Glassmorphism background
  static const Color glassBackground = Color(0x1A3B82F6);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF0F9FF);

  // Income & Expense Colors
  static const Color incomeGreen = Color(0xFF10B981);
  static const Color incomeGreenLight = Color(0xFFD1FAE5);
  static const Color expenseRed = Color(0xFFEF4444);
  static const Color expenseRedLight = Color(0xFFFEE2E2);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Gradient for cards
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
