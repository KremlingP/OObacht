import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black12,
      primaryColor: Colors.black,
      textTheme: const TextTheme(
        //Für App-Bar
        displayLarge: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
          .copyWith(background: Colors.white),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black12,
      primaryColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
          .copyWith(background: const Color.fromRGBO(53, 52, 51, 1)),
    );
  }
}
