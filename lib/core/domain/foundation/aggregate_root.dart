import 'entity.dart';

/// Um Aggregate Root é a entidade principal de um agregado.
///
/// Todas as alterações em entidades e Value Objects pertencentes ao
/// agregado devem ocorrer por meio dele.
///
/// Em outras palavras, ele define o limite de consistência do agregado.
///
/// Exemplo:
/// Story é Aggregate Root das fotos, pessoas e comidas.
/// Purchase é Aggregate Root das garrafas adquiridas.
abstract class AggregateRoot extends Entity {
  const AggregateRoot({required super.id});
}
