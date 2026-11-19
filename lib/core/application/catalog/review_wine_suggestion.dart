import '../../domain/entities/wine.dart';
import '../../domain/foundation/domain_exception.dart';
import '../../domain/repositories/wine_repository.dart';
import '../../domain/value_objects/entity_id.dart';
import '../../domain/value_objects/wine_enrichment.dart';

/// Caso de uso "Revisar sugestão" (ADR-024, ADR-027).
///
/// O usuário confirma ou descarta um dado sugerido (por IA ou fonte
/// externa). Só depois de confirmado o dado passa a valer como fato.
class ReviewWineSuggestion {
  ReviewWineSuggestion({required this._wines});

  final WineRepository _wines;

  /// Confirma a sugestão. [now] existe para os testes fixarem o horário.
  Future<Wine> confirm(
    EntityId wineId,
    WineEnrichment field, {
    DateTime? now,
  }) async {
    final wine = await _load(wineId);
    final updated = wine.confirm(field, at: now ?? DateTime.now());
    await _wines.save(updated);
    return updated;
  }

  /// Descarta a sugestão; o campo volta a ficar "não informado".
  Future<Wine> discard(EntityId wineId, WineEnrichment field) async {
    final wine = await _load(wineId);
    final updated = wine.discard(field);
    await _wines.save(updated);
    return updated;
  }

  Future<Wine> _load(EntityId wineId) async {
    final wine = await _wines.findById(wineId);
    if (wine == null) {
      throw const DomainException('Vinho não encontrado no catálogo.');
    }
    return wine;
  }
}
