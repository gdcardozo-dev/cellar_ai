import '../value_objects/entity_id.dart';

/// Classe base para todas as entidades do domínio.
///
/// Em Domain-Driven Design, entidades são comparadas por identidade.
abstract class Entity {
  const Entity({
    required this.id,
  });

  final EntityId id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => Object.hash(runtimeType, id);
}