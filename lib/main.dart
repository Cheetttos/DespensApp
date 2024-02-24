import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/despensa_screen.dart';
import 'package:flutter_application_1/setting/app_value_notifier.dart';
import 'package:flutter_application_1/setting/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: value
                ? ThemeApp.darkTheme(context)
                : ThemeApp.lightTheme(context),
            home: const SplashScreen(),
            routes: {
              "/dash": (BuildContext context) => const DashboardScreen(),
              "/despensa": (BuildContext context) => const DespensaScreen(),
              "/registro": (BuildContext context) => const RegisterScreen(),
            },
          );
        });
  }
}