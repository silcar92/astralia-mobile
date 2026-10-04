import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Cada idioma debe tener exactamente las claves del español (la plantilla). Al agregar un idioma, esta prueba
/// avisa de lo que falte antes de que la pantalla muestre un texto vacío.
void main() {
  Map<String, dynamic> load(File file) =>
      jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  Set<String> keys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  final files = Directory(
    'lib/l10n',
  ).listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();
  final spanish = keys(
    load(files.firstWhere((f) => f.path.endsWith('app_es.arb'))),
  );

  test('hay textos en español e inglés como mínimo', () {
    expect(
      files.map((f) => f.uri.pathSegments.last),
      containsAll(['app_es.arb', 'app_en.arb']),
    );
  });

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    test('$name tiene las mismas claves que español', () {
      final other = keys(load(file));
      expect(spanish.difference(other), isEmpty, reason: 'faltan en $name');
      expect(other.difference(spanish), isEmpty, reason: 'sobran en $name');
    });

    test('$name no tiene textos vacíos', () {
      final arb = load(file);
      for (final key in keys(arb)) {
        expect((arb[key] as String).trim(), isNotEmpty, reason: '$name: $key');
      }
    });
  }
}
