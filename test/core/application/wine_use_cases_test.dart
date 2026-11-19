import 'package:cellar_ai/core/application/catalog/register_wine.dart';
import 'package:cellar_ai/core/application/catalog/review_wine_suggestion.dart';
import 'package:cellar_ai/core/domain/entities/wine.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/provenance.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_enrichment.dart';
import 'package:cellar_ai/infrastructure/in_memory/in_memory_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/real_cellar_12.dart';

void main() {
  late InMemoryWineRepository wines;
  late RegisterWine registerWine;
  late ReviewWineSuggestion review;
  final recorded = DateTime(2026, 11, 19);
  final later = DateTime(2026, 11, 20);
  const luigiBosca = EntityId('luigi-bosca');
  const mendoza = EntityId('mendoza');

  setUp(() {
    wines = InMemoryWineRepository(RealCellar12.wines);
    registerWine = RegisterWine(wines: wines);
    review = ReviewWineSuggestion(wines: wines);
  });

  Wine newWine({
    String id = 'novo',
    String name = 'Insignia Malbec',
    Vintage? vintage,
    Sourced<EntityId>? region,
  }) {
    return Wine(
      id: EntityId(id),
      producerId: luigiBosca,
      name: name,
      vintage: vintage ?? VintageYear(2021),
      region: region,
    );
  }

  group('Cadastrar vinho', () {
    test('vinho novo é salvo no catálogo', () async {
      await registerWine(newWine());

      expect(await wines.findById(const EntityId('novo')), isNotNull);
    });

    test('mesmo vinho com outra grafia é recusado como duplicata', () async {
      // O 007 da adega real: Luigi Bosca, Insignia Malbec, 2022.
      final duplicate = newWine(
        name: 'insignia  MALBEC',
        vintage: VintageYear(2022),
      );

      await expectLater(
        registerWine(duplicate),
        throwsA(
          isA<DuplicateWineException>().having(
            (e) => e.existingWineId,
            'existingWineId',
            RealCellar12.wineId('007'),
          ),
        ),
      );
      expect(await wines.findById(const EntityId('novo')), isNull);
    });

    test('mesmo rótulo em outra safra é um vinho novo', () async {
      await registerWine(newWine(vintage: VintageYear(2021)));

      expect(await wines.findById(const EntityId('novo')), isNotNull);
    });

    test('cadastro com id já existente é recusado', () async {
      await registerWine(newWine());

      await expectLater(
        registerWine(newWine(name: 'Outro vinho')),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('Revisar sugestão', () {
    Provenance suggestion() => Provenance.suggestion(
      origin: DataOrigin.aiSuggestion,
      confidence: ConfidenceLevel.medium,
      recordedAt: recorded,
    );

    test('confirmar salva o vinho com o dado confirmado', () async {
      await registerWine(newWine(region: Sourced(mendoza, suggestion())));

      await review.confirm(
        const EntityId('novo'),
        WineEnrichment.region,
        now: later,
      );

      final saved = await wines.findById(const EntityId('novo'));
      expect(saved!.region!.isConfirmed, isTrue);
      expect(saved.pendingSuggestions, isEmpty);
    });

    test('descartar salva o vinho sem a sugestão', () async {
      await registerWine(newWine(region: Sourced(mendoza, suggestion())));

      await review.discard(const EntityId('novo'), WineEnrichment.region);

      final saved = await wines.findById(const EntityId('novo'));
      expect(saved!.region, isNull);
    });

    test('vinho inexistente é recusado', () async {
      await expectLater(
        review.discard(const EntityId('xx'), WineEnrichment.region),
        throwsA(isA<DomainException>()),
      );
    });
  });
}
