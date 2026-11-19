import '../../domain/entities/acquisition.dart';
import '../../domain/entities/cellar_lot.dart';
import '../../domain/foundation/domain_exception.dart';
import '../../domain/repositories/acquisition_repository.dart';
import '../../domain/repositories/cellar_lot_repository.dart';
import '../../domain/repositories/wine_repository.dart';
import '../../domain/value_objects/acquisition_origin.dart';
import '../../domain/value_objects/entity_id.dart';

/// Caso de uso "Registrar compra" (ADR-026, ADR-031, ADR-037).
///
/// Registra a compra e os seus lotes de uma vez. Valida tudo antes de
/// salvar: se qualquer regra falhar, nada é salvo.
class RegisterPurchase {
  RegisterPurchase({
    required this._acquisitions,
    required this._lots,
    required this._wines,
  });

  final AcquisitionRepository _acquisitions;
  final CellarLotRepository _lots;
  final WineRepository _wines;

  Future<void> call(Acquisition acquisition, List<CellarLot> lots) async {
    if (lots.isEmpty) {
      throw const DomainException('Uma compra precisa de pelo menos um lote.');
    }
    if (await _acquisitions.findById(acquisition.id) != null) {
      throw const DomainException('Esta compra já foi registrada.');
    }
    final total = acquisition.totalPaid;
    final lotIds = <EntityId>{};
    for (final lot in lots) {
      if (lot.acquisitionId != acquisition.id) {
        throw const DomainException(
          'Todos os lotes devem pertencer a esta compra.',
        );
      }
      if (!lotIds.add(lot.id) || await _lots.findById(lot.id) != null) {
        throw const DomainException('Este lote já foi registrado.');
      }
      if (await _wines.findById(lot.wineId) == null) {
        throw const DomainException('O vinho do lote não está no catálogo.');
      }
      final price = lot.unitPrice;
      if (price == null) {
        continue;
      }
      if (acquisition.origin == AcquisitionOrigin.gift) {
        throw const DomainException(
          'Garrafas recebidas de presente não têm preço pago.',
        );
      }
      if (total != null && price.currency != total.currency) {
        throw DomainException(
          'O preço do lote (${price.currency}) deve estar na mesma moeda '
          'da compra (${total.currency}).',
        );
      }
    }

    await _acquisitions.save(acquisition);
    for (final lot in lots) {
      await _lots.save(lot);
    }
  }
}
