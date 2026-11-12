import 'package:cellar_ai/core/domain/entities/country.dart';
import 'package:cellar_ai/core/domain/entities/grape.dart';
import 'package:cellar_ai/core/domain/entities/producer.dart';
import 'package:cellar_ai/core/domain/entities/region.dart';
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
    final argentina = Country(id: const EntityId('ar'), name: 'Argentina');

    test('deve recusar nome vazio', () {
      expect(
        () => Region(id: id, country: argentina, name: ''),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve remover espaços nas pontas do nome', () {
      expect(
        Region(id: id, country: argentina, name: ' Mendoza ').name,
        'Mendoza',
      );
    });
  });
}
