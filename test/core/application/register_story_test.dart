import 'package:cellar_ai/core/application/stories/register_story.dart';
import 'package:cellar_ai/core/domain/entities/story.dart';
import 'package:cellar_ai/core/domain/entities/story_wine.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_disposition.dart';
import 'package:cellar_ai/infrastructure/in_memory/in_memory_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/real_cellar_12.dart';

void main() {
  final today = DateTime(2026, 11, 18);
  late InMemoryCellarLotRepository lots;
  late InMemoryStoryRepository stories;
  late RegisterStory registerStory;

  // Antes de cada teste: adega real "zerada" e repositórios novos.
  setUp(() {
    lots = InMemoryCellarLotRepository(RealCellar12.lots);
    stories = InMemoryStoryRepository();
    registerStory = RegisterStory(stories: stories, lots: lots);
  });

  StoryWine fromCellar(
    String wine, {
    String id = 'sw1',
    String? lot,
    WineDisposition disposition = WineDisposition.consumed,
  }) {
    return StoryWine(
      id: EntityId(id),
      wineId: RealCellar12.wineId(wine),
      cellarLotId: RealCellar12.lotId(lot ?? wine),
      disposition: disposition,
    );
  }

  Story story(List<StoryWine> wines, {String id = 's1'}) {
    return Story(id: EntityId(id), date: today, wines: wines, now: today);
  }

  Future<int> availableIn(String lot) async {
    final found = await lots.findById(RealCellar12.lotId(lot));
    return found!.available;
  }

  test('história de restaurante não mexe na adega', () async {
    final restaurant = StoryWine(
      id: const EntityId('sw1'),
      wineId: RealCellar12.wineId('007'),
    );

    await registerStory(story([restaurant]));

    expect(await stories.findById(const EntityId('s1')), isNotNull);
    expect(await availableIn('007'), 1);
  });

  test('abrir o 007 da adega: lote zera e história é salva', () async {
    await registerStory(story([fromCellar('007')]));

    expect(await availableIn('007'), 0);
    expect(await stories.findById(const EntityId('s1')), isNotNull);
  });

  test('segunda história com o 007 é recusada e nada é salvo', () async {
    await registerStory(story([fromCellar('007')]));

    await expectLater(
      registerStory(story([fromCellar('007')], id: 's2')),
      throwsA(isA<DomainException>()),
    );
    expect(await stories.findById(const EntityId('s2')), isNull);
    expect(await availableIn('007'), 0);
  });

  test('garrafa dada de presente também sai da adega', () async {
    final gift = fromCellar('010', disposition: WineDisposition.gifted);

    await registerStory(story([gift]));

    expect(await availableIn('010'), 0);
  });

  test('vinho diferente do vinho do lote é recusado', () async {
    final wrong = fromCellar('007', lot: '008');

    await expectLater(
      registerStory(story([wrong])),
      throwsA(isA<DomainException>()),
    );
    expect(await availableIn('008'), 1);
    expect(await stories.findById(const EntityId('s1')), isNull);
  });

  test('lote inexistente é recusado', () async {
    final missing = fromCellar('007', lot: '999');

    await expectLater(
      registerStory(story([missing])),
      throwsA(isA<DomainException>()),
    );
  });

  test('duas garrafas de um lote com só 1: nada é salvo', () async {
    final first = fromCellar('007');
    final second = fromCellar('007', id: 'sw2');

    await expectLater(
      registerStory(story([first, second])),
      throwsA(isA<DomainException>()),
    );
    expect(await availableIn('007'), 1);
    expect(await stories.findById(const EntityId('s1')), isNull);
  });

  test('vinhos de lotes diferentes baixam cada lote', () async {
    final first = fromCellar('007');
    final second = fromCellar('008', id: 'sw2');

    await registerStory(story([first, second]));

    expect(await availableIn('007'), 0);
    expect(await availableIn('008'), 0);
  });

  test('história com id já registrado é recusada', () async {
    await registerStory(story([fromCellar('007')]));

    await expectLater(
      registerStory(story([fromCellar('008')])),
      throwsA(isA<DomainException>()),
    );
    expect(await availableIn('008'), 1);
  });
}
