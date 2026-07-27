import '../entities/grape.dart';

/// Representa a participação de uma uva na composição de um vinho.
///
/// Exemplos:
/// - Malbec 100%
/// - Cabernet Sauvignon 70%
/// - Merlot 20%
/// - Cabernet Franc 10%
class GrapeComposition {
  GrapeComposition({
    required this.grape,
    this.percentage,
  }) {
    if (percentage != null &&
        (percentage! < 0 || percentage! > 100)) {
      throw ArgumentError(
        'O percentual deve estar entre 0 e 100.',
      );
    }
  }

  /// Uva participante da composição.
  final Grape grape;

  /// Percentual da uva no corte.
  ///
  /// Pode ser nulo quando essa informação não é conhecida.
  final double? percentage;

  bool get hasPercentage => percentage != null;

  @override
  String toString() {
    if (percentage == null) {
      return grape.name;
    }

    return '${grape.name} (${percentage!.toStringAsFixed(0)}%)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrapeComposition &&
          grape == other.grape &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(grape, percentage);
}