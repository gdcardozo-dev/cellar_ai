import '../foundation/domain_exception.dart';
import '../foundation/entity.dart';

class Producer extends Entity {
  Producer({required super.id, required String name}) : _name = name.trim() {
    if (_name.isEmpty) {
      throw const DomainException('O nome do produtor não pode ser vazio.');
    }
  }

  final String _name;

  String get name => _name;

  Producer rename(String newName) {
    return Producer(id: id, name: newName);
  }

  @override
  String toString() => name;
}
