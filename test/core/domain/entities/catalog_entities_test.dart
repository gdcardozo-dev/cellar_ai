import 'package:cellar_ai/core/domain/entities/country.dart';
import 'package:cellar_ai/core/domain/entities/grape.dart';
import 'package:cellar_ai/core/domain/entities/producer.dart';
import 'package:cellar_ai/core/domain/entities/region.dart';
import 'package:cellar_ai/core/domain/foundation/aggregate_root.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const id = EntityId('id-1');

  group('Country', () {
    test('deve remover espaços nas pontas do nome', () {
      expect(Country(id: id, name: '  Argentina ').name, 'Argentina');
    });

    test('deve recusar nome vazio', () {
      expect(
        () => Country(id: id, name: '   '),
        throwsA(isA<DomainException>()),
      );
    });

    test('instâncias com o mesmo id devem ser iguais', () {
      expect(
        Country(id: id, name: 'Argentina'),
        equals(Country(id: id, name: 'Argentina (corrigido)')),
      );
    });
  });

  group('Grape', () {
    test('deve recusar nome vazio', () {
      expect(() => Grape(id: id, name: ''), throwsA(isA<DomainException>()));
    });

    test('deve remover espaços nas pontas do nome', () {
      expect(Grape(id: id, name: ' Malbec ').name, 'Malbec');
    });
  });

  group('Producer', () {
    test('deve recusar nome vazio', () {
      expect(() => Producer(id: id, name: ''), throwsA(isA<DomainException>()));
    });

    test('deve remover espaços nas pontas do nome', () {
      expect(Producer(id: id, name: ' Catena Zapata ').name, 'Catena Zapata');
    });
  });

  group('Region', () {
    const argentina = EntityId('ar');

    test('deve guardar o id do país', () {
      final region = Region(id: id, countryId: argentina, name: 'Mendoza');

      expect(region.countryId, argentina);
    });

    test('deve recusar nome vazio', () {
      expect(
        () => Region(id: id, countryId: argentina, name: ''),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve remover espaços nas pontas do nome', () {
      expect(
        Region(id: id, countryId: argentina, name: ' Mendoza ').name,
        'Mendoza',
      );
    });

    test('rename deve manter o id e o país', () {
      final region = Region(id: id, countryId: argentina, name: 'Mendosa');
      final renamed = region.rename('Mendoza');

      expect(renamed.name, 'Mendoza');
      expect(renamed.id, id);
      expect(renamed.countryId, argentina);
    });
  });

  group('Catálogo — Aggregate Roots (ADR-019)', () {
    test('entidades do catálogo devem ser Aggregate Roots', () {
      expect(Country(id: id, name: 'Argentina'), isA<AggregateRoot>());
      expect(Grape(id: id, name: 'Malbec'), isA<AggregateRoot>());
      expect(Producer(id: id, name: 'Catena'), isA<AggregateRoot>());
      expect(
        Region(id: id, countryId: id, name: 'Mendoza'),
        isA<AggregateRoot>(),
      );
    });
  });
}
