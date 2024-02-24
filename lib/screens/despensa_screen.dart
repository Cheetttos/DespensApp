import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/products_database.dart';
import 'package:flutter_application_1/model/products_model.dart';
import 'package:flutter_application_1/setting/app_value_notifier.dart';
import 'package:intl/intl.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});

  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {
  ProductsDatabase? productsDB;

  @override
  void initState() {
    super.initState();
    productsDB = new ProductsDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi despensa :)'),
        actions: [
          IconButton(
              onPressed: () {
                showModal(context, null);
              },
              icon: const Icon(Icons.shopping_bag))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: AppValueNotifier.banProducts,
          builder: (context, value, _) {
            return FutureBuilder(
                future: productsDB!.CONSULTAR(),
                builder:
                    (context, AsyncSnapshot<List<ProductosModel>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Algo salio mal :('),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return itemDespensa(snapshot.data![index]);
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                });
          }),
    );
  }

  Widget itemDespensa(ProductosModel producto) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.cyanAccent, width: 2)),
      height: 100,
      child: Column(
        children: [
          Text('${producto.nomProducto!}'),
          Text('${producto.fechaCaducidad!}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    showModal(context, producto);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }

  showModal(context, ProductosModel? producto) {
    final conNombre = TextEditingController();
    final conCantidad = TextEditingController();
    final conFecha = TextEditingController();

    if (producto != null) {
      conNombre.text = producto.nomProducto!;
      conCantidad.text = producto.canProducto!.toString();
      conFecha.text = producto.fechaCaducidad!;
    }

    final txtNombre = TextFormField(
      keyboardType: TextInputType.text,
      controller: conNombre,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final txtCantidad = TextFormField(
      keyboardType: TextInputType.number,
      controller: conCantidad,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );

    final space = SizedBox(
      height: 10,
    );

    final btnAgregar = ElevatedButton.icon(
        onPressed: () {
          if (producto == null) {
            productsDB!.INSERTAR({
              "nomProducto": conNombre.text,
              "canProducto": int.parse(conCantidad.text),
              "fechaCaducidad": conFecha.text,
            }).then((value) {
              Navigator.pop(context);
              String msj = "";
              if (value > 0) {
                AppValueNotifier.banProducts.value =
                    !AppValueNotifier.banProducts.value;
                msj = "Producto insertado";
              } else {
                msj = "ocurrio un error";
              }
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          } else {
            productsDB!.ACTUALIZAR({
              "idProducto": producto.idProducto,
              "nomProducto": conNombre.text,
              "canProducto": int.parse(conCantidad.text),
              "fechaCaducidad": conFecha.text,
            }).then((value) {
              Navigator.pop(context);
              String msj = "";
              if (value > 0) {
                AppValueNotifier.banProducts.value =
                    !AppValueNotifier.banProducts.value;
                msj = "Producto actualizado";
              } else {
                msj = "ocurrio un error";
              }
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Guardar'));

    final txtFecha = TextFormField(
      keyboardType: TextInputType.none,
      controller: conFecha,
      decoration: const InputDecoration(border: OutlineInputBorder()),
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
