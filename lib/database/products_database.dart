import 'dart:io';

import 'package:flutter_application_1/model/products_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductsDatabase {
  static final NAMEDB = 'DESPENSADB';
  static final VERSIONDB = 1;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null)
      return _database!; //este objeto no debe de ser nulo, con el signo de admiración
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDb = join(folder.path, NAMEDB);
    return openDatabase(
      pathDb,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query = '''CREATE TABLE tblProductos(
          idProducto INTEGER PRIMARY KEY,
          nomProducto VARCHAR(30),
          canProducto INTEGER, 
          fechaCaducidad VARCHAR(10)
        )''';
        db.execute(query);
      },
    );
  }

  Future<int> INSERTAR(Map<String, dynamic> data) async {
    final conexion = await database;
    return conexion.insert('tblProductos', data);
  }

  Future<int> ACTUALIZAR(Map<String, dynamic> data) async {
    final conexion = await database;
    return conexion.update(
      'tblProductos',
      data,
      where: 'idProducto = ?',
      whereArgs: [
        data[
            'idProducto'], // es para buscar el id del producto, los valores que tenga son la cantidad de signos de interrogación que se tengan
      ],
    );
  }

  Future<int> ELIMINAR(int idProducto) async {
    final conexion = await database;
    return conexion.delete(
      'tblProductos',
      where: 'idProducto = ?',
      whereArgs: [
        idProducto,
      ],
    );
  }

  Future<List<ProductosModel>> CONSULTAR() async {
    var conexion = await database;
    var products = await conexion.query('tblProductos');
    return products.map((product) => ProductosModel.fromMap(product)).toList();
  }
}
