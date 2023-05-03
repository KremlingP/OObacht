import 'package:flutter/material.dart';
import 'package:oobacht/globals.dart' as globals;

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.light;

  static Color darkModeBackgroundColor = const Color.fromRGBO(53, 52, 51, 1);

  ThemeMode get currentTheme => _themeMode;

  void toggleTheme(ThemeMode newTheme) {
    _themeMode = newTheme;
    globals.globalThemeMode = _themeMode;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black12,
      primaryColor: Colors.black,
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
          .copyWith(background: Colors.white),
      cardColor: Colors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black12,
      primaryColor: Colors.white,
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
          .copyWith(background: darkModeBackgroundColor),
      cardColor: darkModeBackgroundColor,
    );
  }
}
