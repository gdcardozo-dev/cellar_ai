import 'package:cellar_ai/core/domain/entities/story.dart';
import 'package:cellar_ai/core/domain/entities/story_wine.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/dish.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/rating.dart';
import 'package:cellar_ai/core/domain/value_objects/wine_disposition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 11, 18, 10);
  const insignia = EntityId('insignia');
  const catenaUnknown = EntityId('catena-desconhecida');
  const catena2019 = EntityId('catena-2019');
  const lot = EntityId('lote-1');
  const ana = EntityId('ana');

  StoryWine restaurantWine({String id = 'sw1'}) =>
      StoryWine(id: EntityId(id), wineId: catenaUnknown);

  StoryWine cellarWine({String id = 'sw2'}) =>
      StoryWine(id: EntityId(id), wineId: insignia, cellarLotId: lot);

  Story story({
    DateTime? date,
    List<StoryWine>? wines,
    List<EntityId> peopleIds = const [],
  }) {
    return Story(
      id: const EntityId('s1'),
      date: date ?? today,
      wines: wines ?? [restaurantWine()],
      peopleIds: peopleIds,
      now: today,
    );
  }

  group('StoryWine', () {
    test('vinho bebido pode ter nota, comentário e pratos', () {
      final wine = StoryWine(
        id: const EntityId('sw1'),
        wineId: insignia,
        rating: Rating(5),
        comment: ' Excelente ',
        dishes: [Dish('Cordeiro')],
      );

      expect(wine.disposition, WineDisposition.consumed);
      expect(wine.rating, Rating(5));
      expect(wine.comment, 'Excelente');
      expect(wine.dishes, hasLength(1));
    });

    test('vinho presenteado sem nota deve ser aceito', () {
      final wine = StoryWine(
        id: const EntityId('sw1'),
        wineId: insignia,
        disposition: WineDisposition.gifted,
      );

      expect(wine.disposition, WineDisposition.gifted);
    });

    test('vinho presenteado com nota deve ser recusado', () {
      expect(
        () => StoryWine(
          id: const EntityId('sw1'),
          wineId: insignia,
          disposition: WineDisposition.gifted,
          rating: Rating(4),
        ),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve indicar se veio da adega', () {
      expect(restaurantWine().isFromCellar, isFalse);
      expect(cellarWine().isFromCellar, isTrue);
    });
  });

  group('Story — criação', () {
    test('deve aceitar a história mínima: data e um vinho', () {
      final s = story();

      expect(s.wines, hasLength(1));
      expect(s.title, isNull);
      expect(s.rating, isNull);
    });

    test('deve recusar história sem vinho', () {
      expect(() => story(wines: []), throwsA(isA<DomainException>()));
    });

    test('deve aceitar data de hoje, em qualquer horário', () {
      expect(story(date: DateTime(2026, 11, 18, 23, 59)).date.day, 18);
    });

    test('deve recusar data futura', () {
      expect(
        () => story(date: DateTime(2026, 11, 19)),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve recusar pessoa repetida', () {
      expect(
        () => story(peopleIds: [ana, ana]),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve recusar dois vinhos com o mesmo id', () {
      expect(
        () => story(wines: [restaurantWine(), restaurantWine()]),
        throwsA(isA<DomainException>()),
      );
    });

    test('título em branco deve ser tratado como não informado', () {
      final s = Story(
        id: const EntityId('s1'),
        date: today,
        wines: [restaurantWine()],
        title: '   ',
        now: today,
      );

      expect(s.title, isNull);
    });

    test('as listas não devem poder ser alteradas de fora', () {
      final s = story();

      expect(() => s.wines.add(cellarWine()), throwsUnsupportedError);
      expect(() => s.peopleIds.add(ana), throwsUnsupportedError);
    });
  });

  group('Story — replaceWine', () {
    test('deve trocar o vinho e manter os demais dados', () {
      final s = story(wines: [restaurantWine(), cellarWine()]);

      final updated = s.replaceWine(const EntityId('sw1'), catena2019);

      expect(updated.wines.first.wineId, catena2019);
      expect(updated.wines.last.wineId, insignia);
      expect(updated.id, s.id);
      expect(updated.date, s.date);
    });

    test('não deve alterar a história original', () {
      final s = story();

      s.replaceWine(const EntityId('sw1'), catena2019);

      expect(s.wines.first.wineId, catenaUnknown);
    });

    test('deve recusar troca de vinho vindo da adega', () {
      final s = story(wines: [cellarWine()]);

      expect(
        () => s.replaceWine(const EntityId('sw2'), catena2019),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve recusar item inexistente', () {
      expect(
        () => story().replaceWine(const EntityId('xx'), catena2019),
        throwsA(isA<DomainException>()),
      );
    });
  });
}
