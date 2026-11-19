import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test('deve guardar o valor em centavos', () {
      final price = Money(cents: 18990, currency: 'BRL');

      expect(price.cents, 18990);
      expect(price.currency, 'BRL');
    });

    test('deve usar BRL como moeda padrão', () {
      expect(Money(cents: 100).currency, 'BRL');
    });

    test('deve normalizar o código da moeda', () {
      expect(Money(cents: 100, currency: ' usd ').currency, 'USD');
    });

    test('deve aceitar valor zero', () {
      expect(Money(cents: 0).cents, 0);
    });

    test('deve recusar valor negativo', () {
      expect(() => Money(cents: -1), throwsA(isA<DomainException>()));
    });

    test('deve recusar código de moeda inválido', () {
      expect(
        () => Money(cents: 100, currency: 'REAL'),
        throwsA(isA<DomainException>()),
      );
      expect(
        () => Money(cents: 100, currency: 'R1'),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve somar valores da mesma moeda', () {
      final total = Money(cents: 10000) + Money(cents: 8990);

      expect(total, equals(Money(cents: 18990)));
    });

    test('deve recusar somar moedas diferentes', () {
      expect(
        () => Money(cents: 100) + Money(cents: 100, currency: 'USD'),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve multiplicar por uma quantidade', () {
      expect(Money(cents: 18990) * 3, equals(Money(cents: 56970)));
    });

    test('deve recusar multiplicador negativo', () {
      expect(() => Money(cents: 100) * -1, throwsA(isA<DomainException>()));
    });

    test('valores iguais na mesma moeda devem ser iguais', () {
      expect(Money(cents: 500), equals(Money(cents: 500)));
    });

    test('mesmo valor em moedas diferentes deve ser diferente', () {
      expect(
        Money(cents: 500),
        isNot(equals(Money(cents: 500, currency: 'USD'))),
      );
    });

    test('deve formatar em formato técnico', () {
      expect(Money(cents: 18990).toString(), 'BRL 189.90');
      expect(Money(cents: 505).toString(), 'BRL 5.05');
      expect(Money(cents: 0).toString(), 'BRL 0.00');
    });
  });
}
