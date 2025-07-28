import 'package:flutter/material.dart';

// Como llamar al color, ejemplo:
// Container(
//   color: AppColors.primary,
// );

class AppColors {
  static const Color onBackgroundDefault = Color(0xFFFAF9F3); // Color por defecto en el fondo
  static const Color onSurface = Color(0xFFFFFFFF); // Color por defecto en la superficie, ejemplos: Cards, contenedores, etc.

  static const Color primary = Color(0xFF3E714A); // Color primario (appbar, navbar, botones principales, etc.)
  static const Color primarySecondary = Color(0xFF598C65); // Color primario secundario
  static const Color primaryVariant = Color(0xFF82A370); // Color primario variante
  static const Color primaryLight = Color(0xFFD0DECA); // Color primario claro
  static const Color primaryProgress = Color(0xFF83BA6A); // Color primario oscuro
  static const Color secondary = Color(0xFFD8B733); // Color secundario
  static const Color secondaryVariant = Color(0xFFD8A73E); // Color secundario variante
  static const Color secondaryLight = Color(0xFFDEDCCA); // Color secundario claro

  static const Color onLineDivider = Color(0xFFA1A1A1); // Color de la linea divisora
  static const Color onBorderTextField = Color(0xFFBDBDBD); // Color del borde del TextField
  static const Color onPrimaryText = Color(0xFF000000); // Color del texto principal
  static const Color onSecondaryText = Color(0xFF9D9D9D); // Color del texto secundario
  static const Color onTertiaryText = Color(0xFF9FB794); // Color del texto terciario
  static const Color onHighlightText = Color(0xFFD8B733); // Color del texto de error

  // Colores para los items del BottomNavigationBar
  static const Color nonSelectedItem = Color(0xFFA6BE9D);
  static const Color selectedItem = Color(0xFFE3F0DF);
  
  static const Color electricError = Color(0xFFAF4343);
  static const Color error = Color(0xFF843D54);
}
