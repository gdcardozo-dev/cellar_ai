import '../../core/domain/entities/cellar_lot.dart';
import '../../core/domain/entities/story.dart';
import '../../core/domain/repositories/cellar_lot_repository.dart';
import '../../core/domain/repositories/story_repository.dart';
import '../../core/domain/value_objects/entity_id.dart';

/// Repositório de lotes em memória: para testes e para a Sprint 2,
/// antes da persistência definitiva (Sprint 3).
class InMemoryCellarLotRepository implements CellarLotRepository {
  InMemoryCellarLotRepository([Iterable<CellarLot> initial = const []]) {
    for (final lot in initial) {
      _lots[lot.id] = lot;
    }
  }

  final _lots = <EntityId, CellarLot>{};

  @override
  Future<CellarLot?> findById(EntityId id) async => _lots[id];

  @override
  Future<void> save(CellarLot lot) async {
    _lots[lot.id] = lot;
  }
}

/// Repositório de histórias em memória.
class InMemoryStoryRepository implements StoryRepository {
  final _stories = <EntityId, Story>{};

  @override
  Future<Story?> findById(EntityId id) async => _stories[id];

  @override
  Future<void> save(Story story) async {
    _stories[story.id] = story;
  }
}
