import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextTheme get text => TextTheme(
        headlineMedium: GoogleFonts.nunitoSans(fontWeight: FontWeight.w900),
        titleMedium: GoogleFonts.barlow(),
        bodyMedium: GoogleFonts.montserrat(),
        labelMedium: GoogleFonts.barlow(fontWeight: FontWeight.w700),
      );
}
