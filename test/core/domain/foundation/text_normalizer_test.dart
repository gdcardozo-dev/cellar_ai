import 'package:cellar_ai/core/domain/foundation/text_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeForComparison', () {
    test('deve ignorar maiúsculas, acentos e espaços extras', () {
      expect(
        normalizeForComparison('  Château   Margaux '),
        normalizeForComparison('chateau margaux'),
      );
    });

    test('deve produzir texto em minúsculas e sem acentos', () {
      expect(normalizeForComparison('Ñandú Reserva'), 'nandu reserva');
      expect(normalizeForComparison('Grüner Veltliner'), 'gruner veltliner');
    });

    test('deve remover acentos escritos como caractere combinado', () {
      final combinedCircumflex = String.fromCharCode(0x0302);

      final text = 'Cha${combinedCircumflex}teau';

      expect(normalizeForComparison(text), 'chateau');
    });

    test('deve manter textos diferentes como diferentes', () {
      expect(
        normalizeForComparison('Catena Alta'),
        isNot(normalizeForComparison('Catena Zapata')),
      );
    });
  });
}
