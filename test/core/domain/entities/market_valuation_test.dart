import 'package:cellar_ai/core/domain/entities/market_valuation.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/money.dart';
import 'package:cellar_ai/core/domain/value_objects/provenance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const insignia = EntityId('insignia');
  const other = EntityId('outro');

  MarketValuation valuation(
    String id, {
    required int cents,
    required DateTime recordedAt,
    EntityId wineId = insignia,
    ValuationKind kind = ValuationKind.replacement,
  }) {
    return MarketValuation(
      id: EntityId(id),
      wineId: wineId,
      value: Money(cents: cents),
      kind: kind,
      provenance: Provenance.user(recordedAt: recordedAt),
    );
  }

  group('MarketValuation', () {
    test('data de referência pode ser desconhecida', () {
      final v = valuation('v1', cents: 18000, recordedAt: DateTime(2026, 11));

      expect(v.referenceDate, isNull);
      expect(v.value, Money(cents: 18000));
    });

    test('estimativa vigente é a registrada mais recentemente', () {
      final history = [
        valuation('v1', cents: 15000, recordedAt: DateTime(2025, 1)),
        valuation('v2', cents: 18000, recordedAt: DateTime(2026, 11)),
        valuation('v3', cents: 16000, recordedAt: DateTime(2026, 3)),
      ];

      final latest = MarketValuation.latestFor(
        history,
        wineId: insignia,
        kind: ValuationKind.replacement,
      );

      expect(latest!.value, Money(cents: 18000));
    });

    test('estimativa nova não apaga as anteriores', () {
      final history = [
        valuation('v1', cents: 15000, recordedAt: DateTime(2025, 1)),
        valuation('v2', cents: 18000, recordedAt: DateTime(2026, 11)),
      ];

      expect(history, hasLength(2));
    });

    test('considera apenas o vinho e o tipo informados', () {
      final history = [
        valuation('v1', cents: 99900, recordedAt: DateTime(2026, 11)),
        valuation(
          'v2',
          cents: 50000,
          recordedAt: DateTime(2026, 12),
          wineId: other,
        ),
        valuation(
          'v3',
          cents: 70000,
          recordedAt: DateTime(2026, 12),
          kind: ValuationKind.resale,
        ),
      ];

      final latest = MarketValuation.latestFor(
        history,
        wineId: insignia,
        kind: ValuationKind.replacement,
      );

      expect(latest!.value, Money(cents: 99900));
    });

    test('sem estimativas: nulo', () {
      expect(
        MarketValuation.latestFor(
          const [],
          wineId: insignia,
          kind: ValuationKind.replacement,
        ),
        isNull,
      );
    });
  });
}
