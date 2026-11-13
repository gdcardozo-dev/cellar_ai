import '../foundation/domain_exception.dart';
import '../foundation/entity.dart';
import '../value_objects/entity_id.dart';

/// Região vinícola (ex.: Mendoza). Referencia o país pelo id (ADR-019).
class Region extends Entity {
  Region({required super.id, required this.countryId, required String name})
    : _name = name.trim() {
    if (_name.isEmpty) {
      throw const DomainException('O nome da região não pode ser vazio.');
    }
  }

  /// Id do país ao qual a região pertence.
  final EntityId countryId;
  final String _name;

  String get name => _name;

  Region rename(String newName) {
    return Region(id: id, countryId: countryId, name: newName);
  }

  @override
  String toString() => name;
}
