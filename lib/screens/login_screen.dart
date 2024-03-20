import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:flutter_application_1/services/email_auth_firebase.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final auth = EmailAuthFirebase();
  final email = TextEditingController();
  final pwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: Icon(Icons.email),
        border: UnderlineInputBorder(),
      ),
      controller: email,
    );

    final pwdUser = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: Icon(Icons.password),
        border: UnderlineInputBorder(),
      ),
      controller: pwd,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/wallpaper.jpg'))),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 420,
                  child: Opacity(
                    opacity: .5,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      height: 158,
                      width: MediaQuery.of(context).size.width * .9,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          txtUser,
                          const SizedBox(
                            height: 10,
                          ),
                          pwdUser
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 50,
                    child: Container(
                      height: 190,
                      width: MediaQuery.of(context).size.width * .9,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SignInButton(Buttons.Email, onPressed: () {
                            setState(() {
                              isLoading = !isLoading;
                            });
                            auth
                                .signInUser(
                                    password: pwd.text, email: email.text)
                                .then((value) {
                              if (!value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('El Usuario no es valido'),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(context, "/dash")
                                    .then((value) {
                                  setState(() {
                                    isLoading = !isLoading;
                                  });
                                });
                              }
                            });

                            /*Future.delayed(new Duration(milliseconds: 5000), () {
                              /*Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => new DashboardScreen(),)
                                );*/
                              Navigator.pushNamed(context, "/dash").then((value) {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                              });
                            });*/
                          }),
                          SignInButton(Buttons.Google, onPressed: () {}),
                          SignInButton(Buttons.Facebook, onPressed: () {}),
                          //SignInButton(Buttons.GitHub, onPressed: () {}),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                            },
                            child: Container(
                              height: 35,
                              width: 320,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Center(
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                isLoading
                    ? const Positioned(
                        top: 260,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
