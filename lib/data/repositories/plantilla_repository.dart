import '../../models/plantilla.dart';
import '../database_helper.dart';

class PlantillaRepository {
  final _helper = DatabaseHelper.instance;

  Future<List<Plantilla>> obtenerTodas() async {
    final db = await _helper.database;
    final filas = await db.query('plantilla', orderBy: 'titulo COLLATE NOCASE');
    return filas.map(Plantilla.fromMap).toList();
  }

  Future<void> insertar(Plantilla p) async {
    final db = await _helper.database;
    await db.insert('plantilla', p.toMap()..remove('id'));
  }

  Future<void> actualizar(Plantilla p) async {
    final db = await _helper.database;
    await db.update('plantilla', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  Future<void> eliminar(int id) async {
    final db = await _helper.database;
    await db.delete('plantilla', where: 'id = ?', whereArgs: [id]);
  }
}
