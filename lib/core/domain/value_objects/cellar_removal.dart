import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';

/// Motivo de uma baixa avulsa, sem história (ADR-019, ADR-025).
enum RemovalReason {
  /// Garrafa quebrada.
  broken,

  /// Vinho estragado.
  spoiled,

  /// Garrafa dada de presente sem registro de história.
  gifted,

  /// Outro motivo, descrito na observação.
  other,
}

/// Registro de uma baixa avulsa em um lote da adega.
final class CellarRemoval {
  CellarRemoval({
    required this.reason,
    required this.quantity,
    required this.date,
    String? note,
  }) : note = cleanOptionalText(note) {
    if (quantity < 1) {
      throw const DomainException('A baixa deve ser de pelo menos 1 garrafa.');
    }
  }

  final RemovalReason reason;
  final int quantity;
  final DateTime date;
  final String? note;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellarRemoval &&
          other.reason == reason &&
          other.quantity == quantity &&
          other.date == date &&
          other.note == note;

  @override
  int get hashCode => Object.hash(reason, quantity, date, note);
}
