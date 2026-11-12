import '../foundation/domain_exception.dart';

/// Valor monetário em centavos (inteiro) com código de moeda ISO 4217.
///
/// Ex.: R$ 189,90 → `Money(cents: 18990, currency: 'BRL')`.
/// Não há conversão entre moedas no MVP (ADR-020).
final class Money {
  Money({required this.cents, String currency = 'BRL'})
    : currency = currency.trim().toUpperCase() {
    if (cents < 0) {
      throw const DomainException('O valor não pode ser negativo.');
    }
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(this.currency)) {
      throw DomainException(
        'Código de moeda inválido: "$currency". Use 3 letras, como BRL.',
      );
    }
  }

  final int cents;
  final String currency;

  /// Soma dois valores da mesma moeda.
  Money operator +(Money other) {
    _checkSameCurrency(other);
    return Money(cents: cents + other.cents, currency: currency);
  }

  /// Multiplica por uma quantidade (ex.: preço unitário × garrafas).
  Money operator *(int factor) {
    if (factor < 0) {
      throw const DomainException('O multiplicador não pode ser negativo.');
    }
    return Money(cents: cents * factor, currency: currency);
  }

  void _checkSameCurrency(Money other) {
    if (other.currency != currency) {
      throw DomainException(
        'Não é possível somar $currency com ${other.currency}.',
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money && other.cents == cents && other.currency == currency;

  @override
  int get hashCode => Object.hash(cents, currency);

  /// Formato técnico (ex.: "BRL 189.90"). A formatação para o usuário
  /// (ex.: "R$ 189,90") é responsabilidade da camada de apresentação.
  @override
  String toString() {
    final units = cents ~/ 100;
    final decimals = (cents % 100).toString().padLeft(2, '0');
    return '$currency $units.$decimals';
  }
}
