import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../foundation/text_normalizer.dart';

/// Pessoa com quem o usuário compartilhou uma experiência (ADR-017, ADR-022).
///
/// Dado de terceiro: guarda somente o nome (princípio da necessidade) e é
/// privado do usuário.
///
/// Identidade de domínio: o nome normalizado. Duas pessoas com a mesma
/// grafia são a mesma pessoa; homônimos são diferenciados pela grafia
/// ("Ana Bolena", "Ana de Brasília"). Impedir cadastro duplicado é
/// responsabilidade do caso de uso de cadastro.
class Person extends AggregateRoot {
  Person({required super.id, required String name}) : _name = name.trim() {
    if (_name.isEmpty) {
      throw const DomainException('O nome da pessoa não pode ser vazio.');
    }
  }

  final String _name;

  /// Nome como o usuário digitou (sem espaços nas pontas).
  String get name => _name;

  /// Nome usado para comparação: sem maiúsculas, acentos e espaços extras.
  String get normalizedName => normalizeForComparison(_name);

  /// Mesma pessoa, ainda que em outro registro.
  bool isSamePersonAs(Person other) => normalizedName == other.normalizedName;

  @override
  String toString() => name;
}
