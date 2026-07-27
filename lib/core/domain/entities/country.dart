import '../foundation/entity.dart';
import '../value_objects/entity_id.dart';

class Country extends Entity {
  Country({
    required super.id,
    required String name,
  }) : _name = name.trim() {
    if (_name.isEmpty) {
      throw ArgumentError('O nome do país não pode ser vazio.');
    }
  }

  final String _name;

  String get name => _name;

  Country rename(String newName) {
    return Country(
      id: id,
      name: newName,
    );
  }

  @override
  String toString() => name;
}