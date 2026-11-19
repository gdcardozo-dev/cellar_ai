import '../entities/person.dart';
import '../value_objects/entity_id.dart';

/// Contrato para guardar e buscar pessoas.
abstract interface class PersonRepository {
  Future<Person?> findById(EntityId id);

  /// Pessoa com o mesmo nome normalizado, se existir (ADR-022).
  Future<Person?> findByNormalizedName(String normalizedName);

  Future<void> save(Person person);
}
