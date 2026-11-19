import '../foundation/domain_exception.dart';
import 'entity_id.dart';
import 'grape_composition.dart';

/// Composição de uvas de um vinho (ADR-021).
///
/// Regras: ao menos uma uva; a mesma uva não aparece duas vezes; a soma
/// dos percentuais conhecidos não passa de 100%.
final class GrapeBlend {
  GrapeBlend(List<GrapeComposition> grapes)
    : grapes = List.unmodifiable(grapes) {
    if (this.grapes.isEmpty) {
      throw const DomainException('Informe ao menos uma uva.');
    }
    final seen = <EntityId>{};
    var total = 0.0;
    for (final grape in this.grapes) {
      if (!seen.add(grape.grapeId)) {
        throw const DomainException(
          'A mesma uva não pode aparecer duas vezes na composição.',
        );
      }
      total += grape.percentage ?? 0;
    }
    if (total > 100.0001) {
      throw DomainException(
        'A soma dos percentuais das uvas não pode passar de 100%. '
        'Soma informada: ${total.toStringAsFixed(1)}%.',
      );
    }
  }

  /// Uvas da composição. Lista imutável.
  final List<GrapeComposition> grapes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! GrapeBlend || other.grapes.length != grapes.length) {
      return false;
    }
    for (var i = 0; i < grapes.length; i++) {
      if (other.grapes[i] != grapes[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(grapes);
}
