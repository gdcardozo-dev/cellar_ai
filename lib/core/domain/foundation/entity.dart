import '../value_objects/entity_id.dart';

/// Classe base para entidades do domínio.
///
/// Em Domain-Driven Design (DDD), uma entidade é definida por sua identidade,
/// e não apenas por seus atributos.
///
/// Duas entidades são consideradas iguais quando possuem o mesmo tipo concreto
/// e o mesmo EntityId.
abstract class Entity {
  const Entity({required this.id});

  final EntityId id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => Object.hash(runtimeType, id);
}
