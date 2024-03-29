import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthFirebase {
  //instancia de firebase
  final auth = FirebaseAuth.instance;

  //metodo para ingresar
  Future<bool> signUpUser(
      {required String name,
      required String password,
      required String email}) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        userCredential.user!.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> signInUser(
      {required String password, required String email}) async {
    var band = false;
    final userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      //enviar mensaje que no se ha registrado el usuario
      if (userCredential.user!.emailVerified) {
        band = true;
        //enviar mensaje que no se ha validado
      }
    }
    return band;
  }
}
