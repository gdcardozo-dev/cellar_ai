import 'package:cellar_ai/core/domain/entities/wine.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/grape_composition.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const catena = EntityId('catena');
  const malbec = EntityId('malbec');
  const cabernet = EntityId('cabernet');
  final v2021 = VintageYear(2021, currentYear: 2026);
  final v2022 = VintageYear(2022, currentYear: 2026);

  Wine wine({
    String id = 'w1',
    String name = 'Catena Alta Malbec',
    Vintage? vintage,
    List<GrapeComposition> grapes = const [],
  }) {
    return Wine(
      id: EntityId(id),
      producerId: catena,
      name: name,
      vintage: vintage ?? v2022,
      grapes: grapes,
    );
  }

  group('Wine — criação', () {
    test('deve criar um vinho válido', () {
      final w = Wine(
        id: const EntityId('w1'),
        producerId: catena,
        name: ' Catena Alta Malbec ',
        vintage: v2022,
        type: WineType.red,
      );

      expect(w.name, 'Catena Alta Malbec');
      expect(w.type, WineType.red);
      expect(w.grapes, isEmpty);
    });

    test('deve recusar nome vazio', () {
      expect(() => wine(name: '   '), throwsA(isA<DomainException>()));
    });

    test('deve aceitar safra desconhecida', () {
      expect(
        wine(vintage: const UnknownVintage()).vintage,
        isA<UnknownVintage>(),
      );
    });
  });

  group('Wine — uvas', () {
    test('deve aceitar blend com percentuais que somam 100', () {
      final grapes = [
        GrapeComposition(grapeId: cabernet, percentage: 70),
        GrapeComposition(grapeId: malbec, percentage: 30),
      ];
      final w = wine(grapes: grapes);

      expect(w.grapes, hasLength(2));
    });

    test('deve aceitar uvas sem percentual', () {
      final grapes = [
        GrapeComposition(grapeId: cabernet),
        GrapeComposition(grapeId: malbec),
      ];
      final w = wine(grapes: grapes);

      expect(w.grapes, hasLength(2));
    });

    test('deve recusar uva repetida', () {
      final grapes = [
        GrapeComposition(grapeId: malbec, percentage: 50),
        GrapeComposition(grapeId: malbec, percentage: 50),
      ];

      expect(() => wine(grapes: grapes), throwsA(isA<DomainException>()));
    });

    test('deve recusar soma de percentuais acima de 100', () {
      final grapes = [
        GrapeComposition(grapeId: cabernet, percentage: 70),
        GrapeComposition(grapeId: malbec, percentage: 40),
      ];

      expect(() => wine(grapes: grapes), throwsA(isA<DomainException>()));
    });

    test('a lista de uvas não deve poder ser alterada de fora', () {
      final w = wine(grapes: [GrapeComposition(grapeId: malbec)]);

      expect(
        () => w.grapes.add(GrapeComposition(grapeId: cabernet)),
        throwsUnsupportedError,
      );
    });

    test('alterar a lista original não deve afetar o vinho', () {
      final original = [GrapeComposition(grapeId: malbec)];
      final w = wine(grapes: original);

      original.add(GrapeComposition(grapeId: cabernet));

      expect(w.grapes, hasLength(1));
    });
  });

  group('Wine — identidade', () {
    test('registros diferentes do mesmo vinho devem ser o mesmo vinho', () {
      final a = wine(id: 'w1', name: 'Catena Alta Malbec');
      final b = wine(id: 'w2', name: 'catena  alta malbec');

      expect(a.isSameWineAs(b), isTrue);
    });

    test('safras diferentes não devem ser o mesmo vinho', () {
      final a = wine(id: 'w1', vintage: v2021);
      final b = wine(id: 'w2', vintage: v2022);

      expect(a.isSameWineAs(b), isFalse);
      expect(a.isSameLabelAs(b), isTrue);
    });

    test('igualdade de entidade continua sendo pelo id', () {
      final a = wine(id: 'w1');
      final b = wine(id: 'w2');

      expect(a == b, isFalse);
      expect(a.isSameWineAs(b), isTrue);
    });
  });
}
