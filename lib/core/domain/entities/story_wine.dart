import '../foundation/domain_exception.dart';
import '../foundation/entity.dart';
import '../foundation/optional_text.dart';
import '../value_objects/dish.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/rating.dart';
import '../value_objects/wine_disposition.dart';

/// "Vinho da história": a participação de um Wine em uma Story
/// (ADR-016, ADR-030).
///
/// Entidade interna do agregado Story: só é criada ou alterada por meio
/// dela. Tem id próprio para ser localizada dentro da história.
class StoryWine extends Entity {
  StoryWine({
    required super.id,
    required this.wineId,
    this.cellarLotId,
    this.disposition = WineDisposition.consumed,
    this.rating,
    String? comment,
    List<Dish> dishes = const [],
  }) : comment = cleanOptionalText(comment),
       dishes = List.unmodifiable(dishes) {
    if (disposition == WineDisposition.gifted && rating != null) {
      throw const DomainException(
        'Um vinho dado de presente não recebe nota do vinho, '
        'pois não foi provado.',
      );
    }
  }

  /// Vinho do catálogo (obrigatório).
  final EntityId wineId;

  /// Lote da adega de onde a garrafa saiu; nulo se não veio da adega.
  final EntityId? cellarLotId;

  /// Bebido ou presenteado.
  final WineDisposition disposition;

  /// Nota do vinho naquele momento (opcional).
  final Rating? rating;

  /// Comentário sobre o vinho (opcional).
  final String? comment;

  /// Pratos que harmonizaram com este vinho. Lista imutável.
  final List<Dish> dishes;

  bool get isFromCellar => cellarLotId != null;

  /// Cópia com outro vinho, mantendo os demais dados.
  StoryWine withWine(EntityId newWineId) {
    return StoryWine(
      id: id,
      wineId: newWineId,
      cellarLotId: cellarLotId,
      disposition: disposition,
      rating: rating,
      comment: comment,
      dishes: dishes,
    );
  }
}
