import 'package:flutter_test/flutter_test.dart';
import 'package:cellar_ai/core/domain/value_objects/package_size.dart';

void main() {
  group('PackageSize', () {
    test('deve criar um volume válido', () {
      const size = PackageSize(750);

      expect(size.milliliters, 750);
      expect(size.liters, 0.75);
    });

    test('deve reconhecer a garrafa padrão', () {
      expect(PackageSize.standard.isStandardBottle, isTrue);
    });

    test('objetos com mesmo volume devem ser iguais', () {
      expect(const PackageSize(750), equals(const PackageSize(750)));
    });

    test('objetos com volumes diferentes devem ser diferentes', () {
      expect(const PackageSize(750), isNot(equals(const PackageSize(1500))));
    });

    test('deve formatar corretamente em ml', () {
      expect(const PackageSize(750).toString(), '750 ml');
    });

    test('deve formatar corretamente em litros', () {
      expect(const PackageSize(1500).toString(), '1.5 L');
    });
  });
}
