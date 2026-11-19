import '../foundation/text_normalizer.dart';
import 'entity_id.dart';
import 'vintage.dart';

/// Identidade de domínio de um vinho: Produtor + Nome comercial + Safra
/// (ADR-014).
///
/// O nome é comparado já normalizado: maiúsculas, acentos e espaços extras
/// são ignorados.
final class WineIdentity {
  WineIdentity(this.producerId, String name, this.vintage)
    : normalizedName = normalizeForComparison(name);

  final EntityId producerId;
  final String normalizedName;
  final Vintage vintage;

  /// Mesmo rótulo (produtor + nome), em qualquer safra.
  bool isSameLabelAs(WineIdentity other) =>
      producerId == other.producerId && normalizedName == other.normalizedName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WineIdentity && isSameLabelAs(other) && vintage == other.vintage;

  @override
  int get hashCode => Object.hash(producerId, normalizedName, vintage);

  @override
  String toString() => '$producerId | $normalizedName | $vintage';
}
