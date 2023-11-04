import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'package:biblioteca1/libro.dart';

class DBManager {
  static Database? _db;

  static const String ID = 'controlNum';
  static const String ISBN = 'isbn';
  static const String TITULO = 'titulo';
  static const String AUTOR = 'autor';
  static const String EDITORIAL = 'editorial';
  static const String PAGINAS = 'paginas';
  static const String EDICION = 'edicion';
  static const String PHOTO_NAME = 'photo_name';
  static const String TABLE = 'Books';
  static const String DB_NAME = 'books.db';


  //InitDB
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, "
            "$ISBN TEXT, $TITULO TEXT, $AUTOR TEXT, $EDITORIAL TEXT, "
            "$PAGINAS TEXT, $EDICION TEXT, $PHOTO_NAME TEXT)");
  }

  //Insert
  Future<Libro> save(Libro libro) async {
    var dbClient = await _db;
    libro.controlNum = await dbClient!.insert(TABLE, libro.toMap());
    //book.isbn = await dbClient!.insert(TABLE, book.toMap());
    return libro;
  }

  //Select
  Future<List<Libro>> getLibros()async {
    var dbClient = await (db);
    List<Map> maps = await dbClient!.query(TABLE,
        columns: [
          ID,
          ISBN,
          TITULO,
          AUTOR,
          EDITORIAL,
          PAGINAS,
          EDICION,
          PHOTO_NAME
        ]);
    List<Libro> libros = [];
    print(libros.length);
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        print("Datos");
        print(Libro.formMap(maps[i] as Map<String, dynamic>));
        libros.add(Libro.formMap(maps[i] as Map<String, dynamic>));
      }
    }
    return libros;
  }

  //Delete
  Future<int> delete(int id) async {
    var dbClient = await (db);
    return await dbClient!.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  //Update
  Future<int> update(Libro libro) async {
    var dbClient = await (db);
    return await dbClient!.update(TABLE, libro.toMap(),
        where: '$ID = ?', whereArgs: [libro.controlNum]);
  }


  //Close DB
  Future close() async{
    var dbClient = await (db);
    dbClient!.close();
  }

  Future<List<Libro>> searchLibrosByTitle(String title) async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.query(TABLE,
        columns: [
          ID,
          ISBN,
          TITULO,
          AUTOR,
          EDITORIAL,
          PAGINAS,
          EDICION,
          PHOTO_NAME
        ],
        where: "$TITULO LIKE ?",
        whereArgs: ['%$title%']);

    List<Libro> libros = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        libros.add(Libro.formMap(maps[i] as Map<String, dynamic>));
      }
    }

    return libros;
  }


}
