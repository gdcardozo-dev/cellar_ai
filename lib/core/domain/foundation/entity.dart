import 'package:freezed_annotation/freezed_annotation.dart';

/// Classe base para todas as entidades do domínio.
///
/// Em Domain-Driven Design, uma entidade é definida por sua identidade,
/// não apenas pelos seus atributos.
abstract class Entity {
  const Entity({
    required this.id,
  });

  /// Identificador único da entidade.
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => Object.hash(runtimeType, id);
}