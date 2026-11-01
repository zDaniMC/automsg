import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mensaje_programado.dart';
import '../viewmodels/providers.dart';
import 'schedule_form_page.dart';
import 'widgets/empty_state.dart';
import 'widgets/mensaje_tile.dart';

/// Dashboard: próximos mensajes pendientes de envío.
class ScheduledPage extends ConsumerWidget {
  const ScheduledPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajes = ref.watch(mensajesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Próximos mensajes')),
      body: mensajes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudo cargar: $e')),
        data: (lista) {
          final pendientes = lista
              .where((m) => m.estado == EstadoMensaje.pendiente)
              .toList();
          if (pendientes.isEmpty) {
            return const EmptyState(
              icono: Icons.schedule_send_outlined,
              mensaje: 'No tienes mensajes pendientes.\nToca "Programar mensaje" para crear el primero.',
            );
          }
          return ListView.separated(
            itemCount: pendientes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => MensajeTile(mensaje: pendientes[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const ScheduleFormPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Programar mensaje'),
      ),
    );
  }
}
