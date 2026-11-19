import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/package_size.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PackageSize', () {
    test('deve criar um volume válido', () {
      final size = PackageSize(750);

      expect(size.milliliters, 750);
      expect(size.liters, 0.75);
    });

    test('deve reconhecer a garrafa padrão', () {
      expect(PackageSize.standard.isStandardBottle, isTrue);
    });

    test('objetos com mesmo volume devem ser iguais', () {
      expect(PackageSize(750), equals(PackageSize(750)));
    });

    test('objetos com volumes diferentes devem ser diferentes', () {
      expect(PackageSize(750), isNot(equals(PackageSize(1500))));
    });

    test('deve formatar corretamente em ml', () {
      expect(PackageSize(750).toString(), '750 ml');
    });

    test('deve formatar corretamente em litros', () {
      expect(PackageSize(1500).toString(), '1.5 L');
    });

    test('deve recusar volume zero ou negativo', () {
      expect(() => PackageSize(0), throwsA(isA<DomainException>()));
      expect(() => PackageSize(-750), throwsA(isA<DomainException>()));
    });
  });
}
