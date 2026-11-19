import '../foundation/domain_exception.dart';
import 'entity_id.dart';

/// Participação de uma uva na composição de um vinho.
/// Referencia a uva pelo id (ADR-019).
///
/// Exemplos: Malbec 100%; Cabernet Sauvignon 70% + Merlot 30%;
/// uva conhecida com percentual desconhecido.
class GrapeComposition {
  GrapeComposition({required this.grapeId, this.percentage}) {
    if (percentage != null && (percentage! < 0 || percentage! > 100)) {
      throw const DomainException('O percentual deve estar entre 0 e 100.');
    }
  }

  /// Id da uva participante.
  final EntityId grapeId;

  /// Percentual da uva no corte; nulo quando não é conhecido.
  final double? percentage;

  bool get hasPercentage => percentage != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrapeComposition &&
          grapeId == other.grapeId &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(grapeId, percentage);

  @override
  String toString() {
    if (percentage == null) {
      return 'Uva $grapeId';
    }
    return 'Uva $grapeId (${percentage!.toStringAsFixed(0)}%)';
  }
}
