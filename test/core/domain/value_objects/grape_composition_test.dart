import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/grape_composition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const malbec = EntityId('malbec');
  const merlot = EntityId('merlot');

  group('GrapeComposition', () {
    test('deve aceitar uva sem percentual', () {
      final item = GrapeComposition(grapeId: malbec);

      expect(item.grapeId, malbec);
      expect(item.hasPercentage, isFalse);
    });

    test('deve aceitar os limites 0 e 100', () {
      expect(GrapeComposition(grapeId: malbec, percentage: 0).percentage, 0);
      expect(
        GrapeComposition(grapeId: malbec, percentage: 100).percentage,
        100,
      );
    });

    test('deve recusar percentual fora de 0 a 100', () {
      expect(
        () => GrapeComposition(grapeId: malbec, percentage: -1),
        throwsA(isA<DomainException>()),
      );
      expect(
        () => GrapeComposition(grapeId: malbec, percentage: 101),
        throwsA(isA<DomainException>()),
      );
    });

    test('mesma uva e mesmo percentual devem ser iguais', () {
      expect(
        GrapeComposition(grapeId: malbec, percentage: 70),
        equals(GrapeComposition(grapeId: malbec, percentage: 70)),
      );
    });

    test('percentuais diferentes devem ser diferentes', () {
      expect(
        GrapeComposition(grapeId: malbec, percentage: 70),
        isNot(equals(GrapeComposition(grapeId: malbec, percentage: 30))),
      );
    });

    test('uvas diferentes devem ser diferentes', () {
      expect(
        GrapeComposition(grapeId: malbec, percentage: 50),
        isNot(equals(GrapeComposition(grapeId: merlot, percentage: 50))),
      );
    });
  });
}
