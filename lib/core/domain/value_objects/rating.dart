import '../foundation/domain_exception.dart';

/// Nota pessoal, de 1 a 5 (ADR-017).
final class Rating {
  Rating(this.value) {
    if (value < minValue || value > maxValue) {
      throw DomainException(
        'A nota deve estar entre $minValue e $maxValue. Valor informado: $value.',
      );
    }
  }

  static const int minValue = 1;
  static const int maxValue = 5;

  final int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Rating && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$value/$maxValue';
}
