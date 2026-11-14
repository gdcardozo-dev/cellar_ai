import 'package:cellar_ai/core/domain/entities/person.dart';
import 'package:cellar_ai/core/domain/entities/place.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/place_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const id1 = EntityId('id-1');
  const id2 = EntityId('id-2');

  group('Person', () {
    test('deve remover espaços nas pontas do nome', () {
      expect(Person(id: id1, name: '  Ana ').name, 'Ana');
    });

    test('deve recusar nome vazio', () {
      expect(() => Person(id: id1, name: ' '), throwsA(isA<DomainException>()));
    });

    test('mesma grafia deve ser a mesma pessoa', () {
      final a = Person(id: id1, name: 'Ana');
      final b = Person(id: id2, name: ' ANA ');

      expect(a.isSamePersonAs(b), isTrue);
    });

    test('acentos não diferenciam pessoas', () {
      final a = Person(id: id1, name: 'Joao');
      final b = Person(id: id2, name: 'João');

      expect(a.isSamePersonAs(b), isTrue);
    });

    test('homônimos se diferenciam pela grafia', () {
      final a = Person(id: id1, name: 'Ana Bolena');
      final b = Person(id: id2, name: 'Ana de Brasília');

      expect(a.isSamePersonAs(b), isFalse);
    });

    test('igualdade de entidade continua sendo pelo id', () {
      final a = Person(id: id1, name: 'Ana');
      final b = Person(id: id2, name: 'Ana');

      expect(a == b, isFalse);
      expect(a.isSamePersonAs(b), isTrue);
    });
  });

  group('Place', () {
    test('deve recusar nome vazio', () {
      expect(() => Place(id: id1, name: ''), throwsA(isA<DomainException>()));
    });

    test('deve aceitar lugar sem tipo e sem cidade', () {
      final place = Place(id: id1, name: 'Casa da praia');

      expect(place.type, isNull);
      expect(place.city, isNull);
    });

    test('deve guardar tipo e cidade', () {
      final place = Place(
        id: id1,
        name: 'Fasano',
        type: PlaceType.restaurant,
        city: ' São Paulo ',
      );

      expect(place.type, PlaceType.restaurant);
      expect(place.city, 'São Paulo');
    });

    test('cidade em branco deve ser tratada como não informada', () {
      expect(Place(id: id1, name: 'Fasano', city: '   ').city, isNull);
    });

    test('lugares com o mesmo nome e ids diferentes são diferentes', () {
      final a = Place(id: id1, name: 'Bar do Zé', city: 'Campinas');
      final b = Place(id: id2, name: 'Bar do Zé', city: 'Santos');

      expect(a == b, isFalse);
    });

    test('deve exibir a cidade quando informada', () {
      expect(Place(id: id1, name: 'Fasano').toString(), 'Fasano');
      expect(
        Place(id: id1, name: 'Fasano', city: 'São Paulo').toString(),
        'Fasano (São Paulo)',
      );
    });
  });
}
