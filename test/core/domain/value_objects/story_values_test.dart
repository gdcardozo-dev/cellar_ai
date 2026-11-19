import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/foundation/optional_text.dart';
import 'package:cellar_ai/core/domain/value_objects/dish.dart';
import 'package:cellar_ai/core/domain/value_objects/photo.dart';
import 'package:cellar_ai/core/domain/value_objects/rating.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Rating', () {
    test('deve aceitar os limites 1 e 5', () {
      expect(Rating(1).value, 1);
      expect(Rating(5).value, 5);
    });

    test('deve recusar valores fora de 1 a 5', () {
      expect(() => Rating(0), throwsA(isA<DomainException>()));
      expect(() => Rating(6), throwsA(isA<DomainException>()));
    });

    test('notas iguais devem ser iguais', () {
      expect(Rating(4), equals(Rating(4)));
    });
  });

  group('Photo', () {
    test('deve recusar referência vazia', () {
      expect(() => Photo(reference: '  '), throwsA(isA<DomainException>()));
    });

    test('legenda em branco deve ser tratada como não informada', () {
      expect(Photo(reference: 'foto-1', caption: '  ').caption, isNull);
    });
  });

  group('Dish', () {
    test('deve recusar nome vazio', () {
      expect(() => Dish(' '), throwsA(isA<DomainException>()));
    });

    test('deve remover espaços nas pontas', () {
      expect(Dish(' Risoto de cogumelos ').name, 'Risoto de cogumelos');
    });
  });

  group('cleanOptionalText', () {
    test('deve transformar texto em branco em nulo', () {
      expect(cleanOptionalText('   '), isNull);
      expect(cleanOptionalText(null), isNull);
    });

    test('deve remover espaços nas pontas', () {
      expect(cleanOptionalText(' Mendoza '), 'Mendoza');
    });
  });
}
