import 'package:flutter/material.dart';
import 'package:movies/shared/palette.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() {
  ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.secondary,
    ),
    useMaterial3: true,
  );

  return themeData.copyWith(
    textTheme: GoogleFonts.nunitoTextTheme(
      themeData.textTheme,
    ),
  );
}
