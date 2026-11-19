import '../../domain/entities/person.dart';
import '../../domain/foundation/domain_exception.dart';
import '../../domain/repositories/person_repository.dart';
import '../../domain/value_objects/entity_id.dart';

/// A pessoa já está cadastrada com a mesma grafia (ADR-022).
///
/// Informa o id da pessoa existente para a tela oferecer ("Você quis
/// dizer esta pessoa?").
class DuplicatePersonException extends DomainException {
  const DuplicatePersonException(this.existingPersonId)
    : super('Esta pessoa já está cadastrada.');

  final EntityId existingPersonId;
}

/// Caso de uso "Cadastrar pessoa" (ADR-022).
///
/// Mesma grafia normalizada = mesma pessoa. Homônimos se diferenciam pela
/// grafia ("Ana Bolena", "Ana de Brasília").
class RegisterPerson {
  RegisterPerson({required this._people});

  final PersonRepository _people;

  Future<Person> call(Person person) async {
    if (await _people.findById(person.id) != null) {
      throw const DomainException('Este cadastro já existe.');
    }
    final existing = await _people.findByNormalizedName(person.normalizedName);
    if (existing != null) {
      throw DuplicatePersonException(existing.id);
    }
    await _people.save(person);
    return person;
  }
}
