import '../foundation/entity.dart';
import '../value_objects/entity_id.dart';

class Grape extends Entity {
  Grape({required super.id, required String name}) : _name = name.trim() {
    if (_name.isEmpty) {
      throw ArgumentError('O nome da uva não pode ser vazio.');
    }
  }

  final String _name;

  String get name => _name;

  Grape rename(String newName) {
    return Grape(id: id, name: newName);
  }

  @override
  String toString() => name;
}
