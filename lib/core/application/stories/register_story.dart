import '../../domain/entities/cellar_lot.dart';
import '../../domain/entities/story.dart';
import '../../domain/foundation/domain_exception.dart';
import '../../domain/repositories/cellar_lot_repository.dart';
import '../../domain/repositories/story_repository.dart';
import '../../domain/value_objects/entity_id.dart';

/// Caso de uso "Registrar história" (ADR-019, ADR-025).
///
/// 1. Para cada vinho da história que veio da adega, busca o lote,
///    confere se o vinho é o mesmo e retira 1 garrafa.
/// 2. Só depois de tudo validado, salva os lotes e a história.
///
/// Se qualquer regra falhar, nada é salvo.
class RegisterStory {
  /// Quem chama usa os nomes sem sublinhado: `stories:` e `lots:`.
  RegisterStory({required this._stories, required this._lots});

  final StoryRepository _stories;
  final CellarLotRepository _lots;

  Future<Story> call(Story story) async {
    if (await _stories.findById(story.id) != null) {
      throw const DomainException('Esta história já foi registrada.');
    }

    // Lotes já atualizados nesta operação: dois vinhos da mesma história
    // podem sair do mesmo lote.
    final updatedLots = <EntityId, CellarLot>{};
    for (final storyWine in story.wines) {
      final lotId = storyWine.cellarLotId;
      if (lotId == null) {
        continue;
      }
      final lot = updatedLots[lotId] ?? await _lots.findById(lotId);
      if (lot == null) {
        throw const DomainException('Lote da adega não encontrado.');
      }
      if (lot.wineId != storyWine.wineId) {
        throw const DomainException(
          'O vinho da história não corresponde ao vinho do lote da adega.',
        );
      }
      updatedLots[lotId] = lot.takeBottleForStory();
    }

    for (final lot in updatedLots.values) {
      await _lots.save(lot);
    }
    await _stories.save(story);
    return story;
  }
}
