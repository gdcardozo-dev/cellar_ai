import '../foundation/entity.dart';
import '../value_objects/entity_id.dart';
import 'country.dart';

class Region extends Entity {
  Region({
    required super.id,
    required this.country,
    required String name,
  }) : _name = name.trim() {
    if (_name.isEmpty) {
      throw ArgumentError('O nome da região não pode ser vazio.');
    }
  }

  final Country country;
  final String _name;

  String get name => _name;

  Region rename(String newName) {
    return Region(
      id: id,
      country: country,
      name: newName,
    );
  }

  @override
  String toString() => '$name (${country.name})';
}