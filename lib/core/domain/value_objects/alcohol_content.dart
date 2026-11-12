import '../foundation/domain_exception.dart';

/// Teor alcoólico em percentual (0 a 100).
final class AlcoholContent {
  AlcoholContent(this.percentage) {
    if (percentage < 0 || percentage > 100) {
      throw DomainException(
        'O teor alcoólico deve estar entre 0% e 100%. '
        'Valor informado: $percentage%.',
      );
    }
  }

  final double percentage;

  @override
  String toString() => '${percentage.toStringAsFixed(1)}%';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlcoholContent && other.percentage == percentage;

  @override
  int get hashCode => percentage.hashCode;
}
