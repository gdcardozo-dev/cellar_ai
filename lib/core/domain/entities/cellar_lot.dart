import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';
import '../value_objects/cellar_removal.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/money.dart';
import '../value_objects/package_size.dart';
import '../value_objects/package_type.dart';

/// Lote da adega: garrafas idênticas (mesmo vinho e tamanho) de uma
/// compra (ADR-019, ADR-026, ADR-031).
///
/// Invariantes:
/// - quantidade adquirida de pelo menos 1;
/// - quantidade disponível nunca negativa nem maior que a adquirida.
///
/// Imutável: cada retirada devolve um novo lote.
class CellarLot extends AggregateRoot {
  /// [available] é informado ao reconstruir um lote já existente; em um
  /// lote novo, é igual à quantidade adquirida.
  CellarLot({
    required super.id,
    required this.wineId,
    required this.acquisitionId,
    required this.acquiredQuantity,
    PackageSize? packageSize,
    this.packageType = PackageType.bottle,
    int? available,
    this.unitPrice,
    String? batchCode,
    List<CellarRemoval> removals = const [],
  }) : packageSize = packageSize ?? PackageSize.standard,
       available = available ?? acquiredQuantity,
       batchCode = cleanOptionalText(batchCode),
       removals = List.unmodifiable(removals) {
    if (acquiredQuantity < 1) {
      throw const DomainException('Um lote precisa de pelo menos 1 garrafa.');
    }
    if (this.available < 0 || this.available > acquiredQuantity) {
      throw DomainException(
        'A quantidade disponível deve estar entre 0 e $acquiredQuantity.',
      );
    }
  }

  /// Vinho do catálogo.
  final EntityId wineId;

  /// Compra que trouxe este lote.
  final EntityId acquisitionId;

  /// Tamanho das garrafas (padrão: 750 ml).
  final PackageSize packageSize;

  /// Tipo de embalagem (padrão: garrafa).
  final PackageType packageType;

  /// Quantas garrafas chegaram neste lote.
  final int acquiredQuantity;

  /// Quantas garrafas ainda estão na adega.
  final int available;

  /// Preço por garrafa; nulo quando só o total da compra é conhecido.
  final Money? unitPrice;

  /// Código de lote do fabricante (ex.: "L2624426"); nulo quando não
  /// informado. Nunca é usado para inferir a safra.
  final String? batchCode;

  /// Baixas avulsas (quebra, estrago, presente sem história). Imutável.
  final List<CellarRemoval> removals;

  bool get isEmpty => available == 0;

  /// Retira 1 garrafa para uma história (bebida ou presenteada).
  /// Usado pelo caso de uso "Registrar história".
  CellarLot takeBottleForStory() {
    _checkAvailable(1);
    return _copyWith(available: available - 1);
  }

  /// Registra uma baixa avulsa, sem história.
  CellarLot registerRemoval(CellarRemoval removal) {
    _checkAvailable(removal.quantity);
    return _copyWith(
      available: available - removal.quantity,
      removals: [...removals, removal],
    );
  }

  void _checkAvailable(int quantity) {
    if (quantity > available) {
      throw DomainException(
        'Não há garrafas suficientes neste lote: '
        'disponível $available, solicitado $quantity.',
      );
    }
  }

  CellarLot _copyWith({required int available, List<CellarRemoval>? removals}) {
    return CellarLot(
      id: id,
      wineId: wineId,
      acquisitionId: acquisitionId,
      acquiredQuantity: acquiredQuantity,
      packageSize: packageSize,
      packageType: packageType,
      available: available,
      unitPrice: unitPrice,
      batchCode: batchCode,
      removals: removals ?? this.removals,
    );
  }
}
