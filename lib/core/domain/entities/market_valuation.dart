import '../foundation/aggregate_root.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/money.dart';
import '../value_objects/provenance.dart';

/// Tipo de estimativa de valor (ADR-032).
enum ValuationKind {
  /// Quanto custaria comprar o vinho hoje.
  replacement,

  /// Quanto se obteria vendendo o vinho.
  resale,
}

/// Estimativa de valor de mercado de um vinho (ADR-032).
///
/// Não se confunde com o custo pago (Acquisition/CellarLot). Estimativas
/// formam um histórico: uma nova não apaga a anterior.
class MarketValuation extends AggregateRoot {
  MarketValuation({
    required super.id,
    required this.wineId,
    required this.value,
    required this.kind,
    required this.provenance,
    this.referenceDate,
  });

  /// Vinho avaliado.
  final EntityId wineId;

  /// Valor estimado por garrafa, com moeda.
  final Money value;

  final ValuationKind kind;

  /// Data a que a estimativa se refere; nula quando desconhecida.
  final DateTime? referenceDate;

  /// Fonte, confiança, data do registro e confirmação.
  final Provenance provenance;

  /// Estimativa vigente: a registrada mais recentemente para o vinho e o
  /// tipo informados; nula se não houver.
  static MarketValuation? latestFor(
    Iterable<MarketValuation> valuations, {
    required EntityId wineId,
    required ValuationKind kind,
  }) {
    MarketValuation? latest;
    for (final valuation in valuations) {
      if (valuation.wineId != wineId || valuation.kind != kind) {
        continue;
      }
      final recordedAt = valuation.provenance.recordedAt;
      if (latest == null || recordedAt.isAfter(latest.provenance.recordedAt)) {
        latest = valuation;
      }
    }
    return latest;
  }
}
