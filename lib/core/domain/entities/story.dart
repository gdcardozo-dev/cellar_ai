import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/photo.dart';
import '../value_objects/rating.dart';
import 'story_wine.dart';

/// Registro de uma experiência com vinho (ADR-007, ADR-016, ADR-017,
/// ADR-030). Coração do produto: "Cada garrafa conta uma história."
///
/// Invariantes:
/// - pelo menos um vinho;
/// - data não pode estar no futuro;
/// - a mesma pessoa não aparece duas vezes;
/// - cada vinho da história tem id próprio e único.
///
/// Imutável: alterações devolvem uma nova Story.
class Story extends AggregateRoot {
  /// [now] existe para os testes poderem fixar o "hoje".
  Story({
    required super.id,
    required this.date,
    required List<StoryWine> wines,
    String? title,
    this.rating,
    String? notes,
    this.placeId,
    List<EntityId> peopleIds = const [],
    List<Photo> photos = const [],
    DateTime? now,
  }) : title = cleanOptionalText(title),
       notes = cleanOptionalText(notes),
       wines = List.unmodifiable(wines),
       peopleIds = List.unmodifiable(peopleIds),
       photos = List.unmodifiable(photos) {
    if (this.wines.isEmpty) {
      throw const DomainException(
        'Uma história precisa de pelo menos um vinho.',
      );
    }
    if (_dayOf(date).isAfter(_dayOf(now ?? DateTime.now()))) {
      throw const DomainException(
        'A data da história não pode estar no futuro.',
      );
    }
    if (this.peopleIds.toSet().length != this.peopleIds.length) {
      throw const DomainException(
        'A mesma pessoa não pode aparecer duas vezes na história.',
      );
    }
    final wineIds = this.wines.map((wine) => wine.id).toSet();
    if (wineIds.length != this.wines.length) {
      throw const DomainException(
        'Cada vinho da história precisa de um id próprio.',
      );
    }
  }

  /// Dia da experiência.
  final DateTime date;

  /// Título ou ocasião (opcional), ex.: "Aniversário da Ana".
  final String? title;

  /// Nota do momento (opcional).
  final Rating? rating;

  /// Observações livres (opcional).
  final String? notes;

  /// Lugar da experiência (opcional).
  final EntityId? placeId;

  /// Vinhos da história (ao menos um). Lista imutável.
  final List<StoryWine> wines;

  /// Pessoas presentes, sem repetição. Lista imutável.
  final List<EntityId> peopleIds;

  /// Fotos. Lista imutável.
  final List<Photo> photos;

  /// Troca o vinho de um item da história (ex.: completar safra
  /// desconhecida). Recusa itens vindos da adega: nesse caso, a correção
  /// pertence ao lote (ADR-030).
  Story replaceWine(EntityId storyWineId, EntityId newWineId) {
    final index = wines.indexWhere((wine) => wine.id == storyWineId);
    if (index < 0) {
      throw const DomainException('Vinho não encontrado nesta história.');
    }
    final current = wines[index];
    if (current.isFromCellar) {
      throw const DomainException(
        'Este vinho veio da adega. Para corrigi-lo, ajuste o lote da adega.',
      );
    }
    final updated = [...wines];
    updated[index] = current.withWine(newWineId);
    return _copyWith(wines: updated);
  }

  Story _copyWith({required List<StoryWine> wines}) {
    return Story(
      id: id,
      date: date,
      wines: wines,
      title: title,
      rating: rating,
      notes: notes,
      placeId: placeId,
      peopleIds: peopleIds,
      photos: photos,
      // A data já foi validada na criação desta história.
      now: date,
    );
  }

  static DateTime _dayOf(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
