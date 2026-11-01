import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/plantilla.dart';
import '../viewmodels/providers.dart';
import 'widgets/empty_state.dart';

/// Gestor de plantillas: crear, editar y eliminar.
class TemplatesPage extends ConsumerWidget {
  const TemplatesPage({super.key});

  Future<void> _abrirFormulario(BuildContext context, WidgetRef ref,
      [Plantilla? existente]) async {
    final resultado = await showDialog<Plantilla>(
      context: context,
      builder: (_) => _PlantillaDialog(existente: existente),
    );
    if (resultado != null) {
      await ref.read(plantillasProvider.notifier).guardar(resultado);
    }
  }

  Future<void> _confirmarEliminar(
      BuildContext context, WidgetRef ref, Plantilla p) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar plantilla'),
        content: Text('¿Eliminar "${p.titulo}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar == true) {
      await ref.read(plantillasProvider.notifier).eliminar(p.id!);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantillas = ref.watch(plantillasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Plantillas')),
      body: plantillas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('No se pudo cargar: $e')),
        data: (lista) {
          if (lista.isEmpty) {
            return const EmptyState(
              icono: Icons.description_outlined,
              mensaje: 'Aún no tienes plantillas.\nCrea una para reutilizar tus textos.',
            );
          }
          return ListView.separated(
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final p = lista[i];
              return ListTile(
                title: Text(p.titulo),
                subtitle: Text(p.contenido,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => _abrirFormulario(context, ref, p),
                trailing: IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmarEliminar(context, ref, p),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva plantilla'),
      ),
    );
  }
}

class _PlantillaDialog extends StatefulWidget {
  const _PlantillaDialog({this.existente});

  final Plantilla? existente;

  @override
  State<_PlantillaDialog> createState() => _PlantillaDialogState();
}

class _PlantillaDialogState extends State<_PlantillaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _contenido;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.existente?.titulo);
    _contenido = TextEditingController(text: widget.existente?.contenido);
  }

  @override
  void dispose() {
    _titulo.dispose();
    _contenido.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Plantilla(
        id: widget.existente?.id,
        titulo: _titulo.text.trim(),
        contenido: _contenido.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existente == null ? 'Nueva plantilla' : 'Editar plantilla'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titulo,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe un título' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contenido,
              decoration: const InputDecoration(labelText: 'Mensaje'),
              minLines: 3,
              maxLines: 5,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Escribe el mensaje' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        FilledButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
