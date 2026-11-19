import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';
import '../value_objects/acquisition_origin.dart';
import '../value_objects/money.dart';

/// Compra (ou presente recebido) que trouxe garrafas para a adega
/// (ADR-026, ADR-031).
///
/// Os lotes (`CellarLot`) referenciam a compra pelo id. O valor total
/// nunca é rateado automaticamente entre os lotes.
class Acquisition extends AggregateRoot {
  /// [now] existe para os testes poderem fixar o "hoje".
  Acquisition({
    required super.id,
    this.origin = AcquisitionOrigin.purchase,
    this.totalPaid,
    this.date,
    String? supplier,
    DateTime? now,
  }) : supplier = cleanOptionalText(supplier) {
    if (origin == AcquisitionOrigin.gift && totalPaid != null) {
      throw const DomainException('Um presente recebido não tem valor pago.');
    }
    final purchaseDate = date;
    final today = _dayOf(now ?? DateTime.now());
    if (purchaseDate != null && _dayOf(purchaseDate).isAfter(today)) {
      throw const DomainException('A data da compra não pode estar no futuro.');
    }
  }

  /// Compra ou presente recebido.
  final AcquisitionOrigin origin;

  /// Valor total pago, com moeda; nulo quando não informado.
  final Money? totalPaid;

  /// Data da compra; nula quando desconhecida.
  final DateTime? date;

  /// Loja, site ou pessoa de quem foi comprado (opcional).
  final String? supplier;

  static DateTime _dayOf(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
