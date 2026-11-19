import '../foundation/domain_exception.dart';

/// Representa o volume de uma embalagem em mililitros.
///
/// Exemplos:
/// - 750 ml (garrafa padrão)
/// - 375 ml (meia garrafa)
/// - 1500 ml
/// - 3000 ml
///
/// Não possui conhecimento sobre o tipo de embalagem
/// (garrafa, lata, bag-in-box etc.).
final class PackageSize {
  PackageSize(int milliliters) : _milliliters = milliliters {
    if (milliliters <= 0) {
      throw DomainException(
        'O volume deve ser maior que zero. Valor informado: $milliliters ml.',
      );
    }
  }

  final int _milliliters;

  int get milliliters => _milliliters;

  double get liters => _milliliters / 1000;

  bool get isStandardBottle => _milliliters == 750;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageSize && other._milliliters == _milliliters;

  @override
  int get hashCode => _milliliters.hashCode;

  @override
  String toString() {
    if (_milliliters >= 1000) {
      final liters = _milliliters / 1000;

      if (liters == liters.roundToDouble()) {
        return '${liters.toInt()} L';
      }

      return '${liters.toStringAsFixed(1)} L';
    }

    return '$_milliliters ml';
  }

  static final standard = PackageSize(750);
}
