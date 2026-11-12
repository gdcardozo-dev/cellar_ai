import '../foundation/domain_exception.dart';

/// Safra de um vinho. É sempre exatamente um destes três casos:
/// - [VintageYear]: safra declarada (ex.: 2022);
/// - [NonVintage]: vinho sem safra declarada (NV), como muitos espumantes;
/// - [UnknownVintage]: o vinho tem safra, mas o usuário não a registrou.
///
/// Ver ADR-014 e ADR-020.
sealed class Vintage {
  const Vintage();
}

/// Safra declarada, com ano entre [minYear] e o ano atual.
final class VintageYear extends Vintage {
  /// [currentYear] existe para os testes poderem fixar o "ano atual".
  /// No uso normal, é omitido e vale o ano do relógio.
  VintageYear(this.year, {int? currentYear}) {
    final maxYear = currentYear ?? DateTime.now().year;
    if (year < minYear || year > maxYear) {
      throw DomainException(
        'A safra deve estar entre $minYear e $maxYear. Valor informado: $year.',
      );
    }
  }

  static const int minYear = 1800;

  final int year;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VintageYear && other.year == year;

  @override
  int get hashCode => year.hashCode;

  @override
  String toString() => year.toString();
}

/// Vinho sem safra declarada (NV). É um fato sobre o vinho.
final class NonVintage extends Vintage {
  const NonVintage();

  @override
  bool operator ==(Object other) => other is NonVintage;

  @override
  int get hashCode => (NonVintage).hashCode;

  @override
  String toString() => 'NV';
}

/// Safra existe, mas não foi registrada. É falta de informação, não um fato.
/// Nunca deve ser tratada como um ano presumido.
final class UnknownVintage extends Vintage {
  const UnknownVintage();

  @override
  bool operator ==(Object other) => other is UnknownVintage;

  @override
  int get hashCode => (UnknownVintage).hashCode;

  @override
  String toString() => 'Safra desconhecida';
}
