import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsFirebase {
  final util = FirebaseFirestore.instance;

  CollectionReference? _productsCollection;

  ProductsFirebase() {
    _productsCollection = util.collection('productos');
  }

  Stream<QuerySnapshot>? consultar() {
    return _productsCollection?.snapshots();
  }

  Future<void> insertar(Map<String, dynamic> data) async {
    _productsCollection?.doc().set(data);
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) async {
    _productsCollection?.doc(id).update(data);
  }

  Future<void> eliminar(String id) async {
    _productsCollection?.doc(id).delete();
  }
}