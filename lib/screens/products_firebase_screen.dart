import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/products_firebase.dart';
import 'package:intl/intl.dart';

class ProductsFirebaseScreen extends StatefulWidget {
  const ProductsFirebaseScreen({super.key});

  @override
  State<ProductsFirebaseScreen> createState() => _ProductsFirebaseState();
}

class _ProductsFirebaseState extends State<ProductsFirebaseScreen> {
  final productsFirebase = ProductsFirebase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.badge), onPressed: () => showModal(context)),
      appBar: AppBar(
        title: const Text('Hola'),
      ),
      body: StreamBuilder(
        stream: productsFirebase.consultar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Image.network(snapshot.data!.docs[index].get('imagen'));
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
    );
  }

  showModal(
    context,
  ) {
    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Nombre producto'),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Cantidad de productos'),
    );

    final space = SizedBox(
      height: 10,
    );

    final btnAgregar = ElevatedButton.icon(
        onPressed: () {
          productsFirebase.insertar({
            'cantidad': conCantidad.text,
            'fecha_caducidad': conFecha.text,
            'imagen':
                'https://i.etsystatic.com/35698924/r/il/13065c/4495442902/il_794xN.4495442902_saa3.jpg',
            'nombre': conNombre.text
          });
        },
        icon: const Icon(Icons.save),
        label: const Text('Guardar'));

    final txtFecha = TextFormField(
      keyboardType: TextInputType.none,
      controller: conFecha,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Fecha de caducidad'),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            conFecha.text = formattedDate;
          });
        } else {}
      },
    );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(padding: const EdgeInsets.all(10), children: [
          txtNombre,
          space,
          txtCantidad,
          space,
          txtFecha,
          space,
          btnAgregar
        ]);
      },
    );
  }
}
