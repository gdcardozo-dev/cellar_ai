import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/quantity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quantity', () {
    test('deve aceitar zero', () {
      expect(Quantity(0).value, 0);
    });

    test('deve recusar valor negativo', () {
      expect(() => Quantity(-1), throwsA(isA<DomainException>()));
    });

    test('deve aumentar a quantidade', () {
      expect(Quantity(2).increase(3), equals(Quantity(5)));
    });

    test('deve diminuir a quantidade', () {
      expect(Quantity(5).decrease(2), equals(Quantity(3)));
    });

    test('deve permitir retirar tudo', () {
      expect(Quantity(2).decrease(2), equals(Quantity(0)));
    });

    test('deve recusar retirar mais do que há', () {
      expect(() => Quantity(2).decrease(3), throwsA(isA<DomainException>()));
    });

    test('deve recusar somar ou subtrair valor negativo', () {
      expect(() => Quantity(2).increase(-1), throwsA(isA<DomainException>()));
      expect(() => Quantity(2).decrease(-1), throwsA(isA<DomainException>()));
    });
  });
}
