import '../../core/domain/entities/acquisition.dart';
import '../../core/domain/entities/cellar_lot.dart';
import '../../core/domain/entities/person.dart';
import '../../core/domain/entities/story.dart';
import '../../core/domain/entities/wine.dart';
import '../../core/domain/repositories/acquisition_repository.dart';
import '../../core/domain/repositories/cellar_lot_repository.dart';
import '../../core/domain/repositories/person_repository.dart';
import '../../core/domain/repositories/story_repository.dart';
import '../../core/domain/repositories/wine_repository.dart';
import '../../core/domain/value_objects/entity_id.dart';
import '../../core/domain/value_objects/wine_identity.dart';

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

/// Catálogo de vinhos em memória.
class InMemoryWineRepository implements WineRepository {
  InMemoryWineRepository([Iterable<Wine> initial = const []]) {
    for (final wine in initial) {
      _wines[wine.id] = wine;
    }
  }

  final _wines = <EntityId, Wine>{};

  @override
  Future<Wine?> findById(EntityId id) async => _wines[id];

  @override
  Future<Wine?> findByIdentity(WineIdentity identity) async {
    for (final wine in _wines.values) {
      if (wine.identity == identity) {
        return wine;
      }
    }
    return null;
  }

  @override
  Future<void> save(Wine wine) async {
    _wines[wine.id] = wine;
  }
}

/// Compras em memória.
class InMemoryAcquisitionRepository implements AcquisitionRepository {
  InMemoryAcquisitionRepository([Iterable<Acquisition> initial = const []]) {
    for (final acquisition in initial) {
      _acquisitions[acquisition.id] = acquisition;
    }
  }

  final _acquisitions = <EntityId, Acquisition>{};

  @override
  Future<Acquisition?> findById(EntityId id) async => _acquisitions[id];

  @override
  Future<void> save(Acquisition acquisition) async {
    _acquisitions[acquisition.id] = acquisition;
  }
}

/// Pessoas em memória.
class InMemoryPersonRepository implements PersonRepository {
  final _people = <EntityId, Person>{};

  @override
  Future<Person?> findById(EntityId id) async => _people[id];

  @override
  Future<Person?> findByNormalizedName(String normalizedName) async {
    for (final person in _people.values) {
      if (person.normalizedName == normalizedName) {
        return person;
      }
    }
    return null;
  }

  @override
  Future<void> save(Person person) async {
    _people[person.id] = person;
  }
}
