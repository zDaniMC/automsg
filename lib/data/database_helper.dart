import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Acceso único a la base de datos local SQLite (modo offline).
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _abrir();
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), 'automsg.db');
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plantilla(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            contenido TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE mensaje_programado(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_plantilla INTEGER,
            destinatario TEXT NOT NULL,
            contenido TEXT NOT NULL,
            fecha_hora_envio TEXT NOT NULL,
            es_recurrente INTEGER NOT NULL DEFAULT 0,
            estado TEXT NOT NULL DEFAULT 'Pendiente',
            FOREIGN KEY(id_plantilla) REFERENCES plantilla(id) ON DELETE SET NULL
          )
        ''');
      },
    );
  }
}
