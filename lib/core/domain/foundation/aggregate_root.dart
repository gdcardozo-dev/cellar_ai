import 'entity.dart';

/// Um Aggregate Root é uma entidade que controla um conjunto
/// de objetos relacionados.
///
/// Exemplo:
/// Story é Aggregate Root das fotos, pessoas e comidas.
/// Purchase é Aggregate Root das garrafas adquiridas.
abstract class AggregateRoot extends Entity {
  const AggregateRoot({
    required super.id,
  });
}