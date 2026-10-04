# Astralia Mobile

App Flutter 3.41.6 (Dart 3.11) con GetX. Ver `README.md` para arquitectura y comandos. Backend: `../astralia-backend`;
web: `../astralia-frontend` (referencia de pantallas, textos y reglas).

## Cómo se trabaja aquí
- El repo vive en `Z:\projects\astralia-mobile` (disco de Windows) y se enlaza en WSL como `~/projects/astralia/astralia-mobile`.
  Flutter es el de Windows: desde WSL se invoca con
  `cmd.exe /c "cd /d Z:\projects\astralia-mobile && C:\Users\Silver\Flutter\bin\flutter.bat <comando>"`.
  No se instala Flutter en WSL (decisión de Silvestre). La salida larga de `flutter test` conviene redirigirla a un archivo.
- Antes de cada commit: `dart format lib test`, `flutter analyze`, `flutter test`.
- Commits SIN líneas de coautoría de IA (igual que el resto de repos de Astralia).
- Español neutro (tuteo, sin voseo) en todos los textos; el inglés va en `app_en.arb`.

## Reglas de producto no negociables (PRD)
- "Connect / Connected / Disconnect", nunca "Follow".
- Chat solo con conexión mutua. Nunca mostrar ubicación exacta ni fecha de nacimiento de otra persona.
- Publicidad siempre distinguible. Los grupos de edad 16-17 y 18+ nunca se mezclan.

## graphify
Tras modificar código: `graphify update .` (si existe `graphify-out/`).
