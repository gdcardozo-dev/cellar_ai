import '../foundation/domain_exception.dart';

/// Prato que harmonizou com um vinho em uma história (ADR-017).
final class Dish {
  Dish(String name) : name = name.trim() {
    if (this.name.isEmpty) {
      throw const DomainException('O nome do prato não pode ser vazio.');
    }
  }

  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Dish && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
