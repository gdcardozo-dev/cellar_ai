import '../../domain/entities/cellar_lot.dart';
import '../../domain/foundation/domain_exception.dart';
import '../../domain/repositories/cellar_lot_repository.dart';
import '../../domain/value_objects/cellar_removal.dart';
import '../../domain/value_objects/entity_id.dart';

/// Caso de uso "Baixa avulsa": quebra, estrago ou presente sem história
/// (ADR-019, ADR-025).
class RegisterCellarRemoval {
  RegisterCellarRemoval({required this._lots});

  final CellarLotRepository _lots;

  Future<CellarLot> call(EntityId lotId, CellarRemoval removal) async {
    final lot = await _lots.findById(lotId);
    if (lot == null) {
      throw const DomainException('Lote da adega não encontrado.');
    }
    final updated = lot.registerRemoval(removal);
    await _lots.save(updated);
    return updated;
  }
}
