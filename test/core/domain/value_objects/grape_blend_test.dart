import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/grape_blend.dart';
import 'package:cellar_ai/core/domain/value_objects/grape_composition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const malbec = EntityId('malbec');
  const cabernet = EntityId('cabernet');

  group('GrapeBlend', () {
    test('deve aceitar blend com percentuais que somam 100', () {
      final blend = GrapeBlend([
        GrapeComposition(grapeId: cabernet, percentage: 70),
        GrapeComposition(grapeId: malbec, percentage: 30),
      ]);

      expect(blend.grapes, hasLength(2));
    });

    test('deve aceitar uvas sem percentual', () {
      final blend = GrapeBlend([
        GrapeComposition(grapeId: cabernet),
        GrapeComposition(grapeId: malbec),
      ]);

      expect(blend.grapes, hasLength(2));
    });

    test('deve recusar composição vazia', () {
      expect(() => GrapeBlend([]), throwsA(isA<DomainException>()));
    });

    test('deve recusar uva repetida', () {
      final grapes = [
        GrapeComposition(grapeId: malbec, percentage: 50),
        GrapeComposition(grapeId: malbec, percentage: 50),
      ];

      expect(() => GrapeBlend(grapes), throwsA(isA<DomainException>()));
    });

    test('deve recusar soma de percentuais acima de 100', () {
      final grapes = [
        GrapeComposition(grapeId: cabernet, percentage: 70),
        GrapeComposition(grapeId: malbec, percentage: 40),
      ];

      expect(() => GrapeBlend(grapes), throwsA(isA<DomainException>()));
    });

    test('a lista não deve poder ser alterada de fora', () {
      final original = [GrapeComposition(grapeId: malbec)];
      final blend = GrapeBlend(original);

      original.add(GrapeComposition(grapeId: cabernet));

      expect(blend.grapes, hasLength(1));
      expect(
        () => blend.grapes.add(GrapeComposition(grapeId: cabernet)),
        throwsUnsupportedError,
      );
    });

    test('composições iguais devem ser iguais', () {
      final a = GrapeBlend([GrapeComposition(grapeId: malbec)]);
      final b = GrapeBlend([GrapeComposition(grapeId: malbec)]);

      expect(a, equals(b));
    });
  });
}
