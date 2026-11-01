import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/mensaje_programado.dart';
import '../../viewmodels/providers.dart';

final _formatoFecha = DateFormat('dd/MM/yyyy HH:mm');

class MensajeTile extends ConsumerWidget {
  const MensajeTile({super.key, required this.mensaje});

  final MensajeProgramado mensaje;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(mensaje.destinatario),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mensaje.contenido, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14),
              const SizedBox(width: 4),
              Text(_formatoFecha.format(mensaje.fechaHoraEnvio)),
              if (mensaje.esRecurrente) ...[
                const SizedBox(width: 10),
                const Icon(Icons.repeat, size: 14),
                const SizedBox(width: 4),
                const Text('Recurrente'),
              ],
            ],
          ),
        ],
      ),
      isThreeLine: true,
      trailing: _EstadoChip(estado: mensaje.estado),
      onTap: () => mostrarAccionesMensaje(context, ref, mensaje),
    );
  }
}

class _EstadoChip extends StatelessWidget {
  const _EstadoChip({required this.estado});

  final String estado;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final (fondo, texto) = switch (estado) {
      EstadoMensaje.enviado => (esquema.primaryContainer, esquema.onPrimaryContainer),
      EstadoMensaje.fallido => (esquema.errorContainer, esquema.onErrorContainer),
      _ => (esquema.secondaryContainer, esquema.onSecondaryContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(estado, style: TextStyle(color: texto, fontSize: 12)),
    );
  }
}

Future<void> mostrarAccionesMensaje(
    BuildContext context, WidgetRef ref, MensajeProgramado m) {
  final notifier = ref.read(mensajesProvider.notifier);
  return showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (m.estado != EstadoMensaje.enviado)
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Marcar como enviado'),
              onTap: () {
                Navigator.pop(ctx);
                notifier.cambiarEstado(m, EstadoMensaje.enviado);
              },
            ),
          if (m.estado != EstadoMensaje.fallido)
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Marcar como fallido'),
              onTap: () {
                Navigator.pop(ctx);
                notifier.cambiarEstado(m, EstadoMensaje.fallido);
              },
            ),
          if (m.estado != EstadoMensaje.pendiente)
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Volver a pendiente'),
              onTap: () {
                Navigator.pop(ctx);
                notifier.cambiarEstado(m, EstadoMensaje.pendiente);
              },
            ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Eliminar'),
            onTap: () {
              Navigator.pop(ctx);
              notifier.eliminar(m);
            },
          ),
        ],
      ),
    ),
  );
}
