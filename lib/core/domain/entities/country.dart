import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';

class Country extends AggregateRoot {
  Country({required super.id, required String name}) : _name = name.trim() {
    if (_name.isEmpty) {
      throw const DomainException('O nome do país não pode ser vazio.');
    }
  }

  final String _name;

  String get name => _name;

  Country rename(String newName) {
    return Country(id: id, name: newName);
  }

  @override
  String toString() => name;
}
