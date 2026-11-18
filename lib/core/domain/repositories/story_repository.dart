import '../entities/story.dart';
import '../value_objects/entity_id.dart';

/// Contrato para guardar e buscar histórias.
abstract interface class StoryRepository {
  Future<Story?> findById(EntityId id);

  Future<void> save(Story story);
}
