class Plantilla {
  const Plantilla({this.id, required this.titulo, required this.contenido});

  final int? id;
  final String titulo;
  final String contenido;

  Map<String, Object?> toMap() => {
        'id': id,
        'titulo': titulo,
        'contenido': contenido,
      };

  factory Plantilla.fromMap(Map<String, Object?> map) => Plantilla(
        id: map['id'] as int?,
        titulo: map['titulo'] as String,
        contenido: map['contenido'] as String,
      );
}
