import 'package:cellar_ai/core/domain/entities/cellar_lot.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/services/collection_summary.dart';
import 'package:cellar_ai/core/domain/value_objects/drinking_window.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/money.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/real_cellar_12.dart';

/// Critérios de aceite do `docs/PRODUCT_EVOLUTION_PLAN.md`, seção 6,
/// verificados com a adega real de 12 garrafas.
void main() {
  CollectionSummary summary({List<CellarLot>? lots}) {
    return CollectionSummary.of(
      wines: RealCellar12.wines,
      lots: lots ?? RealCellar12.lots,
      acquisitions: RealCellar12.acquisitions,
      valuations: RealCellar12.valuations,
    );
  }

  group('Adega real — 12 garrafas', () {
    test('12 garrafas: Portugal 6, Argentina 3, Chile 2, Itália 1', () {
      final s = summary();
      final expected = {
        const EntityId('pt'): 6,
        const EntityId('ar'): 3,
        const EntityId('cl'): 2,
        const EntityId('it'): 1,
      };

      expect(s.availableBottles, 12);
      expect(s.availableBottlesByCountry, expected);
    });

    test('custo pago por moeda, sem conversão e sem rateio', () {
      final s = summary();
      final expected = {
        'BRL': Money(cents: 59993),
        'EUR': Money(cents: 2000, currency: 'EUR'),
      };

      expect(s.paidByCurrency, expected);
    });

    test('lotes da compra Grand Cru não têm preço individual', () {
      for (final id in ['001', '002', '003', '004']) {
        expect(RealCellar12.lotOf(id).unitPrice, isNull);
      }
    });

    test('estimativa de reposição dos vinhos 005–012: R\$ 925,00', () {
      final s = summary();

      expect(s.estimatedByCurrency, {'BRL': Money(cents: 92500)});
      expect(s.bottlesWithoutEstimate, 4);
    });

    test('estimativas são sugestões não confirmadas e sem data', () {
      for (final valuation in RealCellar12.valuations) {
        expect(valuation.provenance.isSuggestion, isTrue);
        expect(valuation.provenance.confirmed, isFalse);
        expect(valuation.referenceDate, isNull);
      }
    });

    test('vinhos 001 e 012 têm safra desconhecida, nunca um ano', () {
      expect(RealCellar12.wineOf('001').vintage, isA<UnknownVintage>());
      expect(RealCellar12.wineOf('012').vintage, isA<UnknownVintage>());
    });

    test('código de lote do 012 é guardado e não vira safra', () {
      expect(RealCellar12.lotOf('012').batchCode, 'L2624426');
      expect(RealCellar12.wineOf('012').vintage, isA<UnknownVintage>());
    });

    test('os 12 vinhos são vinhos diferentes', () {
      final wines = RealCellar12.wines;

      for (var i = 0; i < wines.length; i++) {
        for (var j = i + 1; j < wines.length; j++) {
          expect(wines[i].isSameWineAs(wines[j]), isFalse);
        }
      }
    });

    test('nenhum tipo de vinho foi inventado', () {
      for (final wine in RealCellar12.wines) {
        expect(wine.type, isNull);
      }
    });

    test('sem janela de consumo: status "Sem informação"', () {
      final result = ConsumptionAssessment.of(null, currentYear: 2026);

      expect(result.status, ConsumptionStatus.noInformation);
    });
  });

  group('Adega real — história com o vinho 007', () {
    test('abrir o 007 deixa 0 disponível; nova tentativa é recusada', () {
      final opened = RealCellar12.lotOf('007').takeBottleForStory();

      expect(opened.available, 0);
      expect(opened.takeBottleForStory, throwsA(isA<DomainException>()));
    });

    test('depois de abrir o 007, o resumo é atualizado', () {
      final lots = [
        for (final lot in RealCellar12.lots)
          lot.id == RealCellar12.lotId('007') ? lot.takeBottleForStory() : lot,
      ];

      final s = summary(lots: lots);

      expect(s.availableBottles, 11);
      expect(s.availableBottlesByCountry[const EntityId('ar')], 2);
      expect(s.estimatedByCurrency, {'BRL': Money(cents: 74500)});
      expect(s.paidByCurrency['BRL'], Money(cents: 59993));
    });
  });
}
