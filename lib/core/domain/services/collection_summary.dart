import '../entities/acquisition.dart';
import '../entities/cellar_lot.dart';
import '../entities/market_valuation.dart';
import '../entities/wine.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/money.dart';

/// Resumo da coleção para o painel simples do MVP (ADR-023, ADR-026,
/// ADR-032).
///
/// Regras:
/// - valores são agrupados por moeda, sem conversão (ADR-020);
/// - custo pago soma o valor total das compras informadas, sem rateio
///   (ADR-026), incluindo garrafas já consumidas (custo histórico);
/// - valor estimado = estimativa de reposição vigente × garrafas
///   disponíveis; garrafas sem estimativa são contadas à parte.
final class CollectionSummary {
  const CollectionSummary._({
    required this.availableBottles,
    required this.availableBottlesByCountry,
    required this.paidByCurrency,
    required this.estimatedByCurrency,
    required this.bottlesWithoutEstimate,
  });

  factory CollectionSummary.of({
    required Iterable<Wine> wines,
    required Iterable<CellarLot> lots,
    required Iterable<Acquisition> acquisitions,
    required Iterable<MarketValuation> valuations,
  }) {
    final winesById = {for (final wine in wines) wine.id: wine};
    final byCountry = <EntityId?, int>{};
    final estimated = <String, Money>{};
    var available = 0;
    var withoutEstimate = 0;

    for (final lot in lots) {
      if (lot.isEmpty) {
        continue;
      }
      available += lot.available;
      final countryId = winesById[lot.wineId]?.countryId;
      byCountry[countryId] = (byCountry[countryId] ?? 0) + lot.available;
      final estimate = MarketValuation.latestFor(
        valuations,
        wineId: lot.wineId,
        kind: ValuationKind.replacement,
      );
      if (estimate == null) {
        withoutEstimate += lot.available;
      } else {
        _add(estimated, estimate.value * lot.available);
      }
    }

    final paid = <String, Money>{};
    for (final acquisition in acquisitions) {
      final total = acquisition.totalPaid;
      if (total != null) {
        _add(paid, total);
      }
    }

    return CollectionSummary._(
      availableBottles: available,
      availableBottlesByCountry: Map.unmodifiable(byCountry),
      paidByCurrency: Map.unmodifiable(paid),
      estimatedByCurrency: Map.unmodifiable(estimated),
      bottlesWithoutEstimate: withoutEstimate,
    );
  }

  /// Garrafas disponíveis na adega.
  final int availableBottles;

  /// Garrafas disponíveis por país (chave nula: país não informado).
  final Map<EntityId?, int> availableBottlesByCountry;

  /// Custo pago, por código de moeda.
  final Map<String, Money> paidByCurrency;

  /// Valor estimado de reposição das garrafas disponíveis, por moeda.
  final Map<String, Money> estimatedByCurrency;

  /// Garrafas disponíveis sem estimativa de valor.
  final int bottlesWithoutEstimate;

  static void _add(Map<String, Money> totals, Money value) {
    final current = totals[value.currency];
    totals[value.currency] = current == null ? value : current + value;
  }
}
