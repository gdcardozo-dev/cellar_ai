import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';
import '../value_objects/place_type.dart';

/// Local de uma experiência: restaurante, casa, vinícola... (ADR-017,
/// ADR-022).
///
/// Privado do usuário. Lugares com o mesmo nome podem ser lugares
/// diferentes (ex.: dois "Bar do Zé" em cidades distintas); a identidade
/// é apenas o id.
class Place extends AggregateRoot {
  Place({required super.id, required String name, this.type, String? city})
    : _name = name.trim(),
      city = cleanOptionalText(city) {
    if (_name.isEmpty) {
      throw const DomainException('O nome do lugar não pode ser vazio.');
    }
  }

  final String _name;

  /// Tipo do lugar; nulo quando não informado.
  final PlaceType? type;

  /// Cidade, em texto livre; nula quando não informada.
  final String? city;

  String get name => _name;

  @override
  String toString() => city == null ? name : '$name ($city)';
}
