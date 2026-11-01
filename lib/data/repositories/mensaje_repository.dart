import '../../models/mensaje_programado.dart';
import '../database_helper.dart';

class MensajeRepository {
  final _helper = DatabaseHelper.instance;

  Future<List<MensajeProgramado>> obtenerTodos() async {
    final db = await _helper.database;
    final filas = await db.query('mensaje_programado', orderBy: 'fecha_hora_envio');
    return filas.map(MensajeProgramado.fromMap).toList();
  }

  Future<void> insertar(MensajeProgramado m) async {
    final db = await _helper.database;
    await db.insert('mensaje_programado', m.toMap()..remove('id'));
  }

  Future<void> actualizarEstado(int id, String estado) async {
    final db = await _helper.database;
    await db.update('mensaje_programado', {'estado': estado},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> eliminar(int id) async {
    final db = await _helper.database;
    await db.delete('mensaje_programado', where: 'id = ?', whereArgs: [id]);
  }
}
