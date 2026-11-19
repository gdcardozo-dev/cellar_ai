import '../foundation/domain_exception.dart';

/// Quantidade inteira de itens (ex.: garrafas). Nunca negativa.
final class Quantity {
  Quantity(this.value) {
    if (value < 0) {
      throw DomainException(
        'A quantidade não pode ser negativa. Valor informado: $value.',
      );
    }
  }

  final int value;

  Quantity increase(int amount) {
    _checkAmount(amount);
    return Quantity(value + amount);
  }

  /// Lança [DomainException] se o resultado ficar negativo.
  Quantity decrease(int amount) {
    _checkAmount(amount);
    if (amount > value) {
      throw DomainException(
        'Não é possível retirar $amount; há apenas $value disponível(is).',
      );
    }
    return Quantity(value - amount);
  }

  static void _checkAmount(int amount) {
    if (amount < 0) {
      throw const DomainException(
        'O valor a somar ou subtrair não pode ser negativo.',
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Quantity && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
