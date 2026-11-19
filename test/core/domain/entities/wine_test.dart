import 'package:cellar_ai/core/domain/entities/wine.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/alcohol_content.dart';
import 'package:cellar_ai/core/domain/value_objects/drinking_window.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/grape_blend.dart';
import 'package:cellar_ai/core/domain/value_objects/grape_composition.dart';
import 'package:cellar_ai/core/domain/value_objects/provenance.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_enrichment.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const catena = EntityId('catena');
  const malbec = EntityId('malbec');
  const mendoza = EntityId('mendoza');
  final v2021 = VintageYear(2021, currentYear: 2026);
  final v2022 = VintageYear(2022, currentYear: 2026);
  final recorded = DateTime(2026, 11, 19);
  final later = DateTime(2026, 11, 20);

  Provenance suggestion() => Provenance.suggestion(
    origin: DataOrigin.aiSuggestion,
    confidence: ConfidenceLevel.medium,
    recordedAt: recorded,
  );

  Wine wine({
    String id = 'w1',
    String name = 'Catena Alta Malbec',
    Vintage? vintage,
    Sourced<EntityId>? region,
    Sourced<AlcoholContent>? alcoholContent,
    Sourced<DrinkingWindow>? drinkingWindow,
  }) {
    return Wine(
      id: EntityId(id),
      producerId: catena,
      name: name,
      vintage: vintage ?? v2022,
      region: region,
      alcoholContent: alcoholContent,
      drinkingWindow: drinkingWindow,
    );
  }

  group('Wine — criação', () {
    test('deve criar um vinho válido, sem dados de enriquecimento', () {
      final w = Wine(
        id: const EntityId('w1'),
        producerId: catena,
        name: ' Catena Alta Malbec ',
        vintage: v2022,
        type: WineType.red,
      );

      expect(w.name, 'Catena Alta Malbec');
      expect(w.type, WineType.red);
      expect(w.region, isNull);
      expect(w.grapes, isNull);
      expect(w.pendingSuggestions, isEmpty);
    });

    test('deve recusar nome vazio', () {
      expect(() => wine(name: '   '), throwsA(isA<DomainException>()));
    });

    test('deve aceitar safra desconhecida', () {
      expect(
        wine(vintage: const UnknownVintage()).vintage,
        isA<UnknownVintage>(),
      );
    });

    test('deve guardar a composição de uvas com procedência', () {
      final blend = GrapeBlend([
        GrapeComposition(grapeId: malbec, percentage: 100),
      ]);
      final w = Wine(
        id: const EntityId('w1'),
        producerId: catena,
        name: 'Catena Alta Malbec',
        vintage: v2022,
        grapes: Sourced(blend, Provenance.user(recordedAt: recorded)),
      );

      expect(w.grapes!.value, blend);
      expect(w.grapes!.isConfirmed, isTrue);
    });
  });

  group('Wine — sugestões', () {
    test('lista os dados ainda não confirmados', () {
      final w = wine(
        region: Sourced(mendoza, suggestion()),
        alcoholContent: Sourced(
          AlcoholContent(14),
          Provenance.user(recordedAt: recorded),
        ),
      );

      expect(w.pendingSuggestions, [WineEnrichment.region]);
    });

    test('confirmar uma sugestão a torna fato e preserva a origem', () {
      final w = wine(region: Sourced(mendoza, suggestion()));

      final confirmed = w.confirm(WineEnrichment.region, at: later);

      expect(confirmed.region!.isConfirmed, isTrue);
      expect(confirmed.region!.value, mendoza);
      expect(confirmed.region!.provenance.origin, DataOrigin.aiSuggestion);
      expect(confirmed.pendingSuggestions, isEmpty);
    });

    test('confirmar não altera o vinho original nem a identidade', () {
      final w = wine(region: Sourced(mendoza, suggestion()));

      final confirmed = w.confirm(WineEnrichment.region, at: later);

      expect(w.region!.isConfirmed, isFalse);
      expect(confirmed.id, w.id);
      expect(confirmed.isSameWineAs(w), isTrue);
    });

    test('confirmar campo vazio é recusado', () {
      expect(
        () => wine().confirm(WineEnrichment.grapes, at: later),
        throwsA(isA<DomainException>()),
      );
    });

    test('descartar uma sugestão deixa o campo não informado', () {
      final w = wine(region: Sourced(mendoza, suggestion()));

      final discarded = w.discard(WineEnrichment.region);

      expect(discarded.region, isNull);
    });

    test('dado confirmado não pode ser descartado', () {
      final w = wine(
        region: Sourced(mendoza, Provenance.user(recordedAt: recorded)),
      );

      expect(
        () => w.discard(WineEnrichment.region),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('Wine — janela de consumo', () {
    final window = DrinkingWindow(fromYear: 2026, untilYear: 2030);

    test('sem janela: sem informação', () {
      expect(
        wine().consumptionIn(2026).status,
        ConsumptionStatus.noInformation,
      );
    });

    test('janela sugerida aparece como sugestão', () {
      final w = wine(drinkingWindow: Sourced(window, suggestion()));

      final result = w.consumptionIn(2027);

      expect(result.status, ConsumptionStatus.bestMoment);
      expect(result.isSuggestion, isTrue);
    });
  });

  group('Wine — identidade', () {
    test('registros diferentes do mesmo vinho devem ser o mesmo vinho', () {
      final a = wine(id: 'w1', name: 'Catena Alta Malbec');
      final b = wine(id: 'w2', name: 'catena  alta malbec');

      expect(a.isSameWineAs(b), isTrue);
    });

    test('safras diferentes não devem ser o mesmo vinho', () {
      final a = wine(id: 'w1', vintage: v2021);
      final b = wine(id: 'w2', vintage: v2022);

      expect(a.isSameWineAs(b), isFalse);
      expect(a.isSameLabelAs(b), isTrue);
    });

    test('igualdade de entidade continua sendo pelo id', () {
      final a = wine(id: 'w1');
      final b = wine(id: 'w2');

      expect(a == b, isFalse);
      expect(a.isSameWineAs(b), isTrue);
    });
  });
}
