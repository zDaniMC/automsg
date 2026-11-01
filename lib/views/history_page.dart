import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mensaje_programado.dart';
import '../viewmodels/providers.dart';
import 'widgets/empty_state.dart';
import 'widgets/mensaje_tile.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String? _filtro; // null = todos

  @override
  Widget build(BuildContext context) {
    final mensajes = ref.watch(mensajesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: _filtro == null,
                  onSelected: (_) => setState(() => _filtro = null),
                ),
                for (final estado in EstadoMensaje.todos)
                  ChoiceChip(
                    label: Text(estado),
                    selected: _filtro == estado,
                    onSelected: (_) => setState(() => _filtro = estado),
                  ),
              ],
            ),
          ),
          Expanded(
            child: mensajes.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('No se pudo cargar: $e')),
              data: (lista) {
                final visibles = lista
                    .where((m) => _filtro == null || m.estado == _filtro)
                    .toList()
                    .reversed
                    .toList();
                if (visibles.isEmpty) {
                  return const EmptyState(
                    icono: Icons.history,
                    mensaje: 'No hay mensajes con este filtro.',
                  );
                }
                return ListView.separated(
                  itemCount: visibles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => MensajeTile(mensaje: visibles[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
