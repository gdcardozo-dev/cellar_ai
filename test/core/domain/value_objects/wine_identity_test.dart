import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_identity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const catena = EntityId('catena');
  const other = EntityId('other');
  final v2021 = VintageYear(2021, currentYear: 2026);
  final v2022 = VintageYear(2022, currentYear: 2026);

  group('WineIdentity', () {
    test('grafias diferentes do mesmo nome devem ter a mesma identidade', () {
      expect(
        WineIdentity(catena, 'Catena Alta', v2022),
        equals(WineIdentity(catena, '  catena   ALTA ', v2022)),
      );
    });

    test('safras diferentes devem ter identidades diferentes', () {
      expect(
        WineIdentity(catena, 'Catena Alta', v2021),
        isNot(equals(WineIdentity(catena, 'Catena Alta', v2022))),
      );
    });

    test('NV deve ser diferente de safra desconhecida', () {
      expect(
        WineIdentity(catena, 'Brut', const NonVintage()),
        isNot(equals(WineIdentity(catena, 'Brut', const UnknownVintage()))),
      );
    });

    test('produtores diferentes devem ter identidades diferentes', () {
      expect(
        WineIdentity(catena, 'Reserva', v2022),
        isNot(equals(WineIdentity(other, 'Reserva', v2022))),
      );
    });

    test('mesmo rótulo em safras diferentes', () {
      final a = WineIdentity(catena, 'Catena Alta', v2021);
      final b = WineIdentity(catena, 'Catena Alta', v2022);

      expect(a.isSameLabelAs(b), isTrue);
    });

    test('rótulos diferentes', () {
      final a = WineIdentity(catena, 'Catena Alta', v2022);
      final b = WineIdentity(catena, 'Catena Zapata', v2022);

      expect(a.isSameLabelAs(b), isFalse);
    });
  });
}
