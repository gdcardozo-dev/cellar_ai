import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';

class Producer extends AggregateRoot {
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
