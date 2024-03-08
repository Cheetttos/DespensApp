import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/detail_movie_screen.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/despensa_screen.dart';
import 'package:flutter_application_1/setting/app_value_notifier.dart';
import 'package:flutter_application_1/setting/theme.dart';
import 'screens/popular_movies_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyAtuUPr-zoPgnZKHuh9rJxBP7BTWQciOMI", // paste your api key here
      appId:
          "1:36345651874:android:8d794f9505a91a42ee2dfb", //paste your app id here
      messagingSenderId: "36345651874", //paste your messagingSenderId here
      projectId: "despensappmovies", //paste your project id here
    ),
  );
  runApp(const MyApp());
}

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
              "/movies": (BuildContext context) => const PopularMoviesScreen(),
              "/detail": (BuildContext context) => const DetailMovieScreen(),
            },
          );
        });
  }
}
