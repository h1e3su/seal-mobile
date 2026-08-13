import 'package:flutter/material.dart';

/// Tactical HUD Color System from Stitch ("Command Deck, Pocket Edition")
class AppColors {
  // Backgrounds & Canvas Surfaces
  static const Color bgBase = Color(0xFF070B14);
  static const Color background = Color(0xFF061424);
  static const Color surface = Color(0xFF061424);
  static const Color surfaceDim = Color(0xFF061424);
  static const Color surfaceBright = Color(0xFF2D3A4C);
  
  // Containers & Panels
  static const Color surfaceContainerLowest = Color(0xFF020F1F);
  static const Color surfaceContainerLow = Color(0xFF0F1C2D);
  static const Color surfaceContainer = Color(0xFF132031);
  static const Color surfaceContainerHigh = Color(0xFF1E2B3C);
  static const Color surfaceContainerHighest = Color(0xFF293547);
  static const Color bgPanel = Color(0xFF0F1826);
  static const Color bgInput = Color(0xFF152238);
  static const Color borderMuted = Color(0xFF1E2E4A);

  // Accents
  static const Color primary = Color(0xFF00D9FF); // Electric Cyan
  static const Color primaryContainer = Color(0xFF00D9FF);
  static const Color onPrimary = Color(0xFF003641);
  static const Color secondary = Color(0xFFADC6FF);
  static const Color secondaryContainer = Color(0xFF0566D9);
  static const Color tertiary = Color(0xFFFFDEAA);
  static const Color tertiaryContainer = Color(0xFFFFBB2A);

  // Text Colors
  static const Color textPrimary = Color(0xFFE6EDF7);
  static const Color onSurface = Color(0xFFD6E3FA);
  static const Color onSurfaceVariant = Color(0xFFBBC9CE);
  static const Color textMuted = Color(0xFF859398);
  static const Color outline = Color(0xFF859398);
  static const Color outlineVariant = Color(0xFF3C494D);

  // Role-Based Wayfinding Accents (4px Card Accent Bar)
  static const Color accentTeam = Color(0xFF38BDF8);       // Sky Blue
  static const Color accentMentor = Color(0xFF2DD4BF);     // Teal
  static const Color accentJudge = Color(0xFFFBBF24);      // Amber
  static const Color accentCoordinator = Color(0xFFA78BFA);// Purple

  // Status Indicators
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusDanger = Color(0xFFEF4444);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFFFB4AB);

  // Legacy compat aliases
  static const Color primaryVariant = Color(0xFF005B6C);

  /// Helper to get semantic role color for HUD cards & badges
  static Color getRoleColor(String? role) {
    if (role == null) return accentTeam;
    final r = role.toLowerCase();
    if (r.contains('mentor')) return accentMentor;
    if (r.contains('judge')) return accentJudge;
    if (r.contains('ec') || r.contains('coordinator')) return accentCoordinator;
    return accentTeam;
  }
}
