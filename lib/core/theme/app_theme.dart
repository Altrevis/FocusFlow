import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          surface: AppColors.surface,
          onSurface: AppColors.text,
          onSurfaceVariant: AppColors.textSecondary,
          surfaceContainerHighest: AppColors.card,
          outline: AppColors.border,
          outlineVariant: AppColors.border.withValues(alpha: 0.5),
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
            .apply(bodyColor: AppColors.text, displayColor: AppColors.text),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.text,
          iconTheme: IconThemeData(color: AppColors.text),
        ),
        cardTheme: const CardThemeData(
          color: AppColors.card,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: AppColors.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintStyle: const TextStyle(color: AppColors.textSecondary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: AppColors.card,
          labelStyle: TextStyle(color: AppColors.text),
          side: BorderSide(color: AppColors.border),
          deleteIconColor: AppColors.textSecondary,
          checkmarkColor: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
        listTileTheme: const ListTileThemeData(
          textColor: AppColors.text,
          iconColor: AppColors.textSecondary,
          subtitleTextStyle: TextStyle(color: AppColors.textSecondary),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return AppColors.textSecondary;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.border;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          space: 1,
          thickness: 1,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          titleTextStyle: const TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(color: AppColors.textSecondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.card,
          contentTextStyle: TextStyle(color: AppColors.text),
          actionTextColor: AppColors.primary,
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          textColor: AppColors.primary,
          iconColor: AppColors.textSecondary,
          collapsedTextColor: AppColors.text,
          collapsedIconColor: AppColors.textSecondary,
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightText,
          onSurfaceVariant: AppColors.lightTextSecondary,
          surfaceContainerHighest: AppColors.lightCard,
          outline: AppColors.lightBorder,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: AppColors.lightText,
          displayColor: AppColors.lightText,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBackground,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.lightText,
          iconTheme: IconThemeData(color: AppColors.lightText),
        ),
        cardTheme: const CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: AppColors.lightBorder),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
          hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.lightTextSecondary,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: AppColors.lightCard,
          labelStyle: TextStyle(color: AppColors.lightText),
          side: BorderSide(color: AppColors.lightBorder),
          deleteIconColor: AppColors.lightTextSecondary,
          checkmarkColor: AppColors.primary,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightText),
        listTileTheme: const ListTileThemeData(
          textColor: AppColors.lightText,
          iconColor: AppColors.lightTextSecondary,
          subtitleTextStyle: TextStyle(color: AppColors.lightTextSecondary),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return AppColors.lightTextSecondary;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return AppColors.primary;
            return AppColors.lightBorder;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightBorder,
          space: 1,
          thickness: 1,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.lightSurface,
          titleTextStyle: const TextStyle(
            color: AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle:
              const TextStyle(color: AppColors.lightTextSecondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.lightBorder),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.lightCard,
          contentTextStyle: TextStyle(color: AppColors.lightText),
          actionTextColor: AppColors.primary,
        ),
        expansionTileTheme: const ExpansionTileThemeData(
          textColor: AppColors.primary,
          iconColor: AppColors.lightTextSecondary,
          collapsedTextColor: AppColors.lightText,
          collapsedIconColor: AppColors.lightTextSecondary,
        ),
      );
}
