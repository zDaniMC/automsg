class EstadoMensaje {
  static const pendiente = 'Pendiente';
  static const enviado = 'Enviado';
  static const fallido = 'Fallido';
  static const todos = [pendiente, enviado, fallido];
}

class MensajeProgramado {
  const MensajeProgramado({
    this.id,
    this.idPlantilla,
    required this.destinatario,
    required this.contenido,
    required this.fechaHoraEnvio,
    this.esRecurrente = false,
    this.estado = EstadoMensaje.pendiente,
  });

  final int? id;
  final int? idPlantilla;
  final String destinatario;
  final String contenido;
  final DateTime fechaHoraEnvio;
  final bool esRecurrente;
  final String estado;

  MensajeProgramado copyWith({String? estado}) => MensajeProgramado(
        id: id,
        idPlantilla: idPlantilla,
        destinatario: destinatario,
        contenido: contenido,
        fechaHoraEnvio: fechaHoraEnvio,
        esRecurrente: esRecurrente,
        estado: estado ?? this.estado,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'id_plantilla': idPlantilla,
        'destinatario': destinatario,
        'contenido': contenido,
        'fecha_hora_envio': fechaHoraEnvio.toIso8601String(),
        'es_recurrente': esRecurrente ? 1 : 0,
        'estado': estado,
      };

  factory MensajeProgramado.fromMap(Map<String, Object?> map) =>
      MensajeProgramado(
        id: map['id'] as int?,
        idPlantilla: map['id_plantilla'] as int?,
        destinatario: map['destinatario'] as String,
        contenido: map['contenido'] as String,
        fechaHoraEnvio: DateTime.parse(map['fecha_hora_envio'] as String),
        esRecurrente: (map['es_recurrente'] as int) == 1,
        estado: map['estado'] as String,
      );
}
