import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:splash_view/source/presentation/pages/pages.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
        backgroundColor: Colors.green[600],
        loadingIndicator: Image.asset('images/login.gif'),
        logo: Image.network(
            'https://celaya.tecnm.mx/wp-content/uploads/2021/02/cropped-FAV.png'),
        done: Done(const LoginScreen(),
            animationDuration: const Duration(milliseconds: 3000)));
  }
}
