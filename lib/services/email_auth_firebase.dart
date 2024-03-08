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
      return false;
    }
  }
}
