import '../entities/wine.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/wine_identity.dart';

/// Contrato para guardar e buscar vinhos do catálogo pessoal.
abstract interface class WineRepository {
  Future<Wine?> findById(EntityId id);

  /// Vinho com a mesma identidade (produtor + nome normalizado + safra),
  /// se existir. Usado para impedir duplicatas (ADR-014).
  Future<Wine?> findByIdentity(WineIdentity identity);

  Future<void> save(Wine wine);
}
