import '../foundation/domain_exception.dart';
import '../foundation/entity.dart';

class Grape extends Entity {
  Grape({required super.id, required String name}) : _name = name.trim() {
    if (_name.isEmpty) {
      throw const DomainException('O nome da uva não pode ser vazio.');
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
