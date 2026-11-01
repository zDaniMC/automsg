import 'package:automsg/models/mensaje_programado.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMap y fromMap conservan los datos del mensaje', () {
    final original = MensajeProgramado(
      id: 1,
      destinatario: 'Ana',
      contenido: 'Hola',
      fechaHoraEnvio: DateTime(2026, 11, 5, 8, 30),
      esRecurrente: true,
    );

    final copia = MensajeProgramado.fromMap(original.toMap());

    expect(copia.destinatario, 'Ana');
    expect(copia.fechaHoraEnvio, DateTime(2026, 11, 5, 8, 30));
    expect(copia.esRecurrente, isTrue);
    expect(copia.estado, EstadoMensaje.pendiente);
  });

  test('copyWith cambia solo el estado', () {
    final m = MensajeProgramado(
      destinatario: 'Luis',
      contenido: 'Reunión',
      fechaHoraEnvio: DateTime(2026, 11, 6, 9),
    );
    final enviado = m.copyWith(estado: EstadoMensaje.enviado);
    expect(enviado.estado, EstadoMensaje.enviado);
    expect(enviado.destinatario, 'Luis');
  });
}
