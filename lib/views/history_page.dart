import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/providers.dart';
import 'widgets/empty_state.dart';
import 'widgets/mensaje_tile.dart';

/// Historial de mensajes: pendientes, enviados y fallidos.
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mensajes = ref.watch(mensajesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: mensajes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudo cargar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const EmptyState(
              icono: Icons.history,
              mensaje: 'Aún no hay mensajes en el historial.',
            );
          }
          final ordenada = lista.reversed.toList();
          return ListView.separated(
            itemCount: ordenada.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => MensajeTile(mensaje: ordenada[i]),
          );
        },
      ),
    );
  }
}
