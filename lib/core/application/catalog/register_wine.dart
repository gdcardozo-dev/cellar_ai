import '../../domain/entities/wine.dart';
import '../../domain/foundation/domain_exception.dart';
import '../../domain/repositories/wine_repository.dart';
import '../../domain/value_objects/entity_id.dart';

/// O vinho já existe no catálogo, com outra grafia ou em outro registro.
///
/// Informa o id do vinho existente para a tela poder oferecê-lo ao
/// usuário ("Você quis dizer este vinho?").
class DuplicateWineException extends DomainException {
  const DuplicateWineException(this.existingWineId)
    : super('Este vinho já está no seu catálogo.');

  final EntityId existingWineId;
}

/// Caso de uso "Cadastrar vinho" (ADR-014, ADR-024, ADR-027).
///
/// Impede duplicatas pela identidade do vinho: "Catena Alta" e
/// "catena  alta" da mesma safra e do mesmo produtor são o mesmo vinho.
class RegisterWine {
  RegisterWine({required this._wines});

  final WineRepository _wines;

  Future<Wine> call(Wine wine) async {
    if (await _wines.findById(wine.id) != null) {
      throw const DomainException('Este cadastro já existe.');
    }
    final existing = await _wines.findByIdentity(wine.identity);
    if (existing != null) {
      throw DuplicateWineException(existing.id);
    }
    await _wines.save(wine);
    return wine;
  }
}
