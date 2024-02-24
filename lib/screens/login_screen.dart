import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final txtUser = TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
    ),
  );

  final pwdUser = TextFormField(
    keyboardType: TextInputType.text,
    obscureText: true,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/wallpaper.jpg'),
        )),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 500,
              child: Opacity(
                opacity: .5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  height: 180,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ListView(
                    children: [
                      txtUser,
                      const SizedBox(
                        height: 10,
                      ), //espacio entre 2 componentes
                      pwdUser
                    ],
                  ),
                ),
              ),
            ),
            Image.asset('images/logo_letras.png'),
            Positioned(
                bottom: 50,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SignInButton(Buttons.Email, onPressed: () {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        Future.delayed(new Duration(milliseconds: 5000), () {
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      new DashboardScreen())));
                        }*/
                          Navigator.pushNamed(context, "/dash")
                              .then((value) => {
                                    setState(
                                      () {
                                        isLoading = !isLoading;
                                      },
                                    )
                                  });
                        });
                      }),
                      SignInButton(Buttons.Facebook, onPressed: () {}),
                      SignInButton(Buttons.Google, onPressed: () {}),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/registro');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(fontSize: 16),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1)),
                        ),
                        child: const Text('Registrate aquí'),
                      )
                    ],
                  ),
                )),
            isLoading
                ? const Positioned(
                    top: 100,
                    child: CircularProgressIndicator(color: Colors.cyan),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
