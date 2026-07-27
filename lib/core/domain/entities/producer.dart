import '../foundation/entity.dart';
import '../value_objects/entity_id.dart';

class Producer extends Entity {
  const Producer({
    required super.id,
    required this.name,
  });

  final String name;

  Producer copyWith({
    EntityId? id,
    String? name,
  }) {
    return Producer(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => name;
}