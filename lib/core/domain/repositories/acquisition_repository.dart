import '../entities/acquisition.dart';
import '../value_objects/entity_id.dart';

/// Contrato para guardar e buscar compras.
abstract interface class AcquisitionRepository {
  Future<Acquisition?> findById(EntityId id);

  Future<void> save(Acquisition acquisition);
}
