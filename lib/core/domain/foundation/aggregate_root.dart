import 'entity.dart';

/// Um Aggregate Root é a entidade principal de um agregado.
///
/// Todas as alterações em entidades e Value Objects pertencentes ao
/// agregado devem ocorrer por meio dele.
///
/// Em outras palavras, ele define o limite de consistência do agregado.
///
/// Exemplos (ADR-019):
/// - Story contém StoryWine e fotos;
/// - Wine é Aggregate Root do catálogo;
/// - CellarLot é Aggregate Root de um lote de garrafas da adega.
///
/// Agregados diferentes se referenciam somente pelo id.
abstract class AggregateRoot extends Entity {
  const AggregateRoot({required super.id});
}
