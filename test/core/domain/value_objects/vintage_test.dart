import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exemplo de "switch exaustivo": se um quarto caso de Vintage existisse
/// e não fosse tratado aqui, o código nem compilaria.
String describe(Vintage vintage) => switch (vintage) {
  VintageYear(:final year) => 'Safra $year',
  NonVintage() => 'Sem safra (NV)',
  UnknownVintage() => 'Safra desconhecida',
};

void main() {
  group('VintageYear', () {
    test('deve aceitar um ano válido', () {
      expect(VintageYear(2022, currentYear: 2026).year, 2022);
    });

    test('deve aceitar os limites 1800 e o ano atual', () {
      expect(VintageYear(1800, currentYear: 2026).year, 1800);
      expect(VintageYear(2026, currentYear: 2026).year, 2026);
    });

    test('deve recusar ano anterior a 1800', () {
      expect(
        () => VintageYear(1500, currentYear: 2026),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve recusar ano futuro', () {
      expect(
        () => VintageYear(2027, currentYear: 2026),
        throwsA(isA<DomainException>()),
      );
    });

    test('safras com o mesmo ano devem ser iguais', () {
      expect(
        VintageYear(2022, currentYear: 2026),
        equals(VintageYear(2022, currentYear: 2026)),
      );
    });

    test('safras com anos diferentes devem ser diferentes', () {
      expect(
        VintageYear(2021, currentYear: 2026),
        isNot(equals(VintageYear(2022, currentYear: 2026))),
      );
    });
  });

  group('NonVintage e UnknownVintage', () {
    test('NV deve ser diferente de safra desconhecida', () {
      expect(const NonVintage(), isNot(equals(const UnknownVintage())));
    });

    test('dois NV devem ser iguais', () {
      expect(const NonVintage(), equals(const NonVintage()));
    });

    test('duas safras desconhecidas devem ser iguais', () {
      expect(const UnknownVintage(), equals(const UnknownVintage()));
    });
  });

  group('switch exaustivo', () {
    test('deve descrever os três casos', () {
      expect(describe(VintageYear(2022, currentYear: 2026)), 'Safra 2022');
      expect(describe(const NonVintage()), 'Sem safra (NV)');
      expect(describe(const UnknownVintage()), 'Safra desconhecida');
    });
  });
}
