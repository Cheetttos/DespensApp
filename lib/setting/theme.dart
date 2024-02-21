import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData lightTheme(BuildContext context) {
    //asignar tipo de dato (BuildContext context)
    final theme = ThemeData.light();
    return theme.copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color.fromARGB(255, 255, 0, 0),
            ));
  }

  static ThemeData darkTheme(BuildContext context) {
    //asignar tipo de dato (BuildContext context)
    final theme = ThemeData.dark();
    return theme.copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: const Color.fromARGB(255, 15, 62, 109)));
  }
}
