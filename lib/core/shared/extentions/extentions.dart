import 'package:flutter/material.dart';

extension MediaQueryHelper on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

extension ThemeHelper on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  InputDecorationTheme get inputDecorationTheme =>
      Theme.of(this).inputDecorationTheme;
  InteractiveInkFeatureFactory get splashFactoryTheme =>
      Theme.of(this).splashFactory;
  Color get primaryColorTheme => Theme.of(this).primaryColor;
  Color get scaffoldBackgroundColorTheme =>
      Theme.of(this).scaffoldBackgroundColor;
  Color get dividerColorTheme => Theme.of(this).dividerColor;
  Color get splashColorTheme => Theme.of(this).splashColor;
  Color get shadowColorTheme => Theme.of(this).shadowColor;
  Color get hoverColorTheme => Theme.of(this).hoverColor;
  Color get highlightColorTheme => Theme.of(this).highlightColor;
  Color get hintColorTheme => Theme.of(this).hintColor;
  Color get cardColorTheme => Theme.of(this).cardColor;
  BottomNavigationBarThemeData get bottomNavigationBarThemeData =>
      Theme.of(this).bottomNavigationBarTheme;
  DialogTheme get dialogTheme => Theme.of(this).dialogTheme;
  ButtonThemeData get buttonThemeData => Theme.of(this).buttonTheme;
  FloatingActionButtonThemeData get floatingActionButtonThemeData =>
      Theme.of(this).floatingActionButtonTheme;
  TextButtonThemeData get textButtonThemeData => Theme.of(this).textButtonTheme;
  ElevatedButtonThemeData get elevationButtonThemeData =>
      Theme.of(this).elevatedButtonTheme;
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      Theme.of(this).outlinedButtonTheme;
}
