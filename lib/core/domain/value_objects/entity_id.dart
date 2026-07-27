import 'package:uuid/uuid.dart';

/// Identificador único de uma entidade do domínio.
///
/// Encapsula a forma como os IDs são gerados, evitando espalhar
/// detalhes técnicos pelo restante do sistema.
class EntityId {
  static const Uuid _uuid = Uuid();

  final String value;

  const EntityId(this.value);

  factory EntityId.generate() {
    return EntityId(_uuid.v4());
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}