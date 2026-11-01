# AutoMsg

AutoMsg es una aplicación móvil (Flutter) que permite programar el envío automático de mensajes en una fecha y hora específicas, con recordatorios inteligentes, plantillas personalizadas e integración con distintas plataformas de mensajería.

## Problema por resolver

Muchas personas olvidan enviar mensajes importantes o pierden tiempo enviando repetidamente la misma información. Esto afecta la comunicación personal, académica y laboral.

## Público objetivo

- Estudiantes
- Profesionales
- Empresas pequeñas
- Emprendedores
- Community Managers
- Personas que administran negocios por WhatsApp

## Funcionalidades clave

1. Programar mensajes para una fecha y hora específicas.
2. Programar mensajes repetitivos (diarios, semanales o mensuales).
3. Plantillas de mensajes personalizadas.
4. Integración con WhatsApp, Telegram, SMS y correo electrónico (según las posibilidades técnicas de cada plataforma).
5. Historial de mensajes programados y enviados.

## Metodología de trabajo

El equipo trabaja con un enfoque híbrido **Scrum + Kanban (Scrumban)**: entregas planificadas por sprint, apoyadas en un tablero Kanban con límites de trabajo en curso para dar seguimiento a tareas de investigación técnica y riesgos externos (por ejemplo, restricciones de APIs de mensajería).

## Reglas de Colaboración

Este repositorio sigue el flujo **GitHub Flow**:

- La rama `main` siempre debe estar en un estado desplegable/estable. Nunca se hacen cambios directos sobre `main`.
- Cada nueva funcionalidad, corrección o tarea se desarrolla en una rama independiente creada a partir de `main`, con el formato:
  - `feature/nombre-funcionalidad` para nuevas funcionalidades.
  - `fix/nombre-del-bug` para correcciones.
  - `docs/nombre-cambio` para cambios de documentación.
- Al terminar el trabajo en una rama, se abre un **Pull Request (PR)** hacia `main` describiendo brevemente qué se hizo y por qué.
- Todo PR requiere **al menos 1 revisión aprobada** antes de poder fusionarse (branch protection activado sobre `main`).
- Una vez aprobado y fusionado el PR, la rama de la funcionalidad se elimina para mantener el repositorio limpio.
- Los conflictos de código se resuelven en la rama de la funcionalidad, nunca directamente en `main`.

## Distribución con Firebase App Distribution

### Flujo
Generar APK → App Distribution → Testers → Instalación → Actualización

### Publicación (cómo replicar el proceso)
1. Actualizar `version` en `pubspec.yaml` (ej. `1.0.1+2`).
2. Ejecutar `flutter clean`, `flutter pub get` y `flutter build apk --release`.
3. En Firebase Console → App Distribution → Versiones, subir
   `build/app/outputs/flutter-apk/app-release.apk`.
4. Asignar el grupo `QA_Clase`, escribir las Release Notes y pulsar **Distribuir**.
5. Compartir el enlace de instalación con los testers.

### Versionado
Formato `versionName+versionCode` en `pubspec.yaml`:

| Versión | Build | Cambio principal |
|---|---|---|
| 1.0.0+1 | 1 | Plantillas, programación e historial |
| 1.0.1+2 | 2 | Filtros por estado en el historial |

El `versionCode` (número después del `+`) se incrementa en cada release.
Cada versión se marca en Git con un tag (`v1.0.0`, `v1.0.1`).

### Formato de Release Notes
Versión (build), fecha, responsable, cambios etiquetados
(`[Nuevo]`, `[Corrección]`, `[Mejora]`), credenciales de prueba y notas para testers.

### Testers
Grupo `QA_Clase`: dduran@uceva.edu.co

### Flujo de ramas
`feature/proyecto-base` → `main` y `feature/app_distribution` → `main`
mediante Pull Request (GitHub Flow, según las reglas de colaboración del proyecto).

## Equipo

- José Daniel Rivas Tenorio

Docente: David Steven Duran Vallejo — Electiva Profesional, UCEVA, 2026.
