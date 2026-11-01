import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/mensaje_programado.dart';
import '../viewmodels/providers.dart';

/// Formulario para programar un mensaje en fecha y hora específicas.
class ScheduleFormPage extends ConsumerStatefulWidget {
  const ScheduleFormPage({super.key});

  @override
  ConsumerState<ScheduleFormPage> createState() => _ScheduleFormPageState();
}

class _ScheduleFormPageState extends ConsumerState<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinatario = TextEditingController();
  final _contenido = TextEditingController();
  DateTime? _fecha;
  TimeOfDay? _hora;
  bool _recurrente = false;
  int? _idPlantilla;

  @override
  void dispose() {
    _destinatario.dispose();
    _contenido.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? ahora,
      firstDate: ahora,
      lastDate: ahora.add(const Duration(days: 365 * 2)),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  Future<void> _elegirHora() async {
    final elegida = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
    );
    if (elegida != null) setState(() => _hora = elegida);
  }

  void _mostrarError(String texto) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fecha == null || _hora == null) {
      _mostrarError('Elige la fecha y la hora de envío.');
      return;
    }
    final envio = DateTime(
        _fecha!.year, _fecha!.month, _fecha!.day, _hora!.hour, _hora!.minute);
    if (!envio.isAfter(DateTime.now())) {
      _mostrarError('La fecha y hora deben ser posteriores a este momento.');
      return;
    }
    await ref.read(mensajesProvider.notifier).programar(
          MensajeProgramado(
            idPlantilla: _idPlantilla,
            destinatario: _destinatario.text.trim(),
            contenido: _contenido.text.trim(),
            fechaHoraEnvio: envio,
            esRecurrente: _recurrente,
          ),
        );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final plantillas = ref.watch(plantillasProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: const Text('Programar mensaje')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _destinatario,
                decoration: const InputDecoration(
                  labelText: 'Destinatario',
                  hintText: 'Nombre o número de contacto',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Escribe el destinatario'
                    : null,
              ),
              const SizedBox(height: 16),
              if (plantillas.isNotEmpty) ...[
                Text('Usar una plantilla',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final p in plantillas)
                      ChoiceChip(
                        label: Text(p.titulo),
                        selected: _idPlantilla == p.id,
                        onSelected: (_) => setState(() {
                          _idPlantilla = p.id;
                          _contenido.text = p.contenido;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _contenido,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 6,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Escribe el mensaje'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _elegirFecha,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_fecha == null
                          ? 'Elegir fecha'
                          : DateFormat('dd/MM/yyyy').format(_fecha!)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _elegirHora,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                          _hora == null ? 'Elegir hora' : _hora!.format(context)),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Repetir este mensaje'),
                value: _recurrente,
                onChanged: (v) => setState(() => _recurrente = v),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _guardar,
                  child: const Text('Programar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
