import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/email_auth_firebase.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? _selectedImage;

  final _keyForm = GlobalKey<FormState>();
  final authFirebase = EmailAuthFirebase();

  final txtEspacio = const SizedBox(
    height: 12,
  );

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final conUser = TextEditingController();
    final conEmailUser = TextEditingController();
    final conPwdUser = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuario'),
      ),
      body: Form(
        key: _keyForm,
        child: Column(children: [
          const Text('Da clic para añadir tu fotografia'),
          Container(
            height: 150,
            decoration: BoxDecoration(
                color: Colors.blueGrey[300],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30)),
            child: _selectedImage != null
                ? IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ListView(
                              padding: const EdgeInsets.all(10),
                              children: [
                                TextButton(
                                    style: TextButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 18),
                                        backgroundColor: Colors.blueGrey[200],
                                        foregroundColor: Colors.black),
                                    onPressed: () async {
                                      await _pickImageFromGallery();
                                      Navigator.pop(context);
                                    },
                                    child:
                                        const Text('Elegir desde la galeria')),
                                TextButton(
                                    style: TextButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 18),
                                        backgroundColor: Colors.blueGrey[200],
                                        foregroundColor: Colors.black),
                                    onPressed: () async {
                                      await _pickImageFromCamera();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Tomar foto')),
                              ]);
                        },
                      );
                    },
                    icon: CircleAvatar(
                      backgroundImage: FileImage(_selectedImage!),
                      radius: 150,
                    ))
                : IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 150,
                            child: ListView(
                                padding: const EdgeInsets.all(10),
                                children: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 18),
                                          backgroundColor: Colors.blueGrey[200],
                                          foregroundColor: Colors.black),
                                      onPressed: () async {
                                        await _pickImageFromGallery();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                          'Elegir desde la galeria')),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 18),
                                          backgroundColor: Colors.blueGrey[200],
                                          foregroundColor: Colors.black),
                                      onPressed: () async {
                                        await _pickImageFromCamera();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Tomar foto')),
                                ]),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.person_2_sharp,
                      size: 100,
                    )),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                txtEspacio,
                TextFormField(
                  controller: conUser,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre completo'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa tu nombre completamente';
                    }
                    return null;
                  },
                ),
                txtEspacio,
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: conEmailUser,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    RegExp emailRegExp = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]{2,}$");
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Tu usuario no cumple con los parametros necesarios';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuario (correo)',
                  ),
                ),
                txtEspacio,
                TextFormField(
                  controller: conPwdUser,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final passRegExp = RegExp(
                        r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$");
                    if (value!.isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    if (value.length < 8) {
                      return 'El minimo de caracteres son 8';
                    }
                    if (!passRegExp.hasMatch(value)) {
                      return 'la contraseña no cumple con los parametros necesarios, min. 8 caracteres, inicial mayus, al menos un numero y caracter especial';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText:
                        'Contraseña (min. 8 caracteres, inicial mayus, al menos un numero y caracter especial)',
                  ),
                ),
                txtEspacio,
                ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      authFirebase
                          .signUpUser(
                              name: conUser.text,
                              password: conPwdUser.text,
                              email: conEmailUser.text)
                          .then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Se registro el usuario')),
                          );
                          //tecnicamente registrado
                        }
                      });
                    } else {
                      // Si el formulario no es válido, muestra un mensaje
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No se pudo registrar al usuario')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey[200],
                      foregroundColor: Colors.black),
                  child: const Text('Registrarse'),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
