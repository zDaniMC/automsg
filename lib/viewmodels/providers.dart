import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/mensaje_repository.dart';
import '../data/repositories/plantilla_repository.dart';
import '../models/mensaje_programado.dart';
import '../models/plantilla.dart';

final plantillaRepositoryProvider =
    Provider<PlantillaRepository>((ref) => PlantillaRepository());
final mensajeRepositoryProvider =
    Provider<MensajeRepository>((ref) => MensajeRepository());

/// ViewModel de plantillas (CRUD).
class PlantillasNotifier extends AsyncNotifier<List<Plantilla>> {
  PlantillaRepository get _repo => ref.read(plantillaRepositoryProvider);

  @override
  Future<List<Plantilla>> build() => _repo.obtenerTodas();

  Future<void> guardar(Plantilla p) async {
    if (p.id == null) {
      await _repo.insertar(p);
    } else {
      await _repo.actualizar(p);
    }
    state = AsyncData(await _repo.obtenerTodas());
  }

  Future<void> eliminar(int id) async {
    await _repo.eliminar(id);
    state = AsyncData(await _repo.obtenerTodas());
  }
}

final plantillasProvider =
    AsyncNotifierProvider<PlantillasNotifier, List<Plantilla>>(
        PlantillasNotifier.new);

/// ViewModel de mensajes programados.
class MensajesNotifier extends AsyncNotifier<List<MensajeProgramado>> {
  MensajeRepository get _repo => ref.read(mensajeRepositoryProvider);

  @override
  Future<List<MensajeProgramado>> build() => _repo.obtenerTodos();

  Future<void> programar(MensajeProgramado m) async {
    await _repo.insertar(m);
    state = AsyncData(await _repo.obtenerTodos());
  }

  Future<void> cambiarEstado(MensajeProgramado m, String estado) async {
    await _repo.actualizarEstado(m.id!, estado);
    state = AsyncData(await _repo.obtenerTodos());
  }

  Future<void> eliminar(MensajeProgramado m) async {
    await _repo.eliminar(m.id!);
    state = AsyncData(await _repo.obtenerTodos());
  }
}

final mensajesProvider =
    AsyncNotifierProvider<MensajesNotifier, List<MensajeProgramado>>(
        MensajesNotifier.new);
