import '../entities/cellar_lot.dart';
import '../value_objects/entity_id.dart';

/// Contrato para guardar e buscar lotes da adega.
///
/// O domínio define o contrato; a infraestrutura decide como guardar
/// (memória, banco local, Firebase...). Os métodos são assíncronos
/// (`Future`) porque um armazenamento real leva tempo para responder.
abstract interface class CellarLotRepository {
  Future<CellarLot?> findById(EntityId id);

  Future<void> save(CellarLot lot);
}
