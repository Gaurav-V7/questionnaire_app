import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
