import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../value_objects/alcohol_content.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/grape_composition.dart';
import '../value_objects/vintage.dart';
import '../value_objects/wine_identity.dart';
import '../value_objects/wine_type.dart';

/// Vinho do catálogo pessoal do usuário (ADR-014, ADR-015, ADR-019).
///
/// Identidade de domínio: Produtor + Nome comercial + Safra.
/// Não contém dados de posse (preço, quantidade, compra): isso pertence ao
/// lote da adega (CellarLot).
///
/// Impedir cadastros duplicados exige consultar o catálogo inteiro e é
/// responsabilidade do caso de uso de cadastro, não deste agregado.
class Wine extends AggregateRoot {
  Wine({
    required super.id,
    required this.producerId,
    required String name,
    required this.vintage,
    this.type,
    this.countryId,
    this.regionId,
    List<GrapeComposition> grapes = const [],
    this.alcoholContent,
  }) : _name = name.trim(),
       grapes = List.unmodifiable(grapes) {
    if (_name.isEmpty) {
      throw const DomainException('O nome do vinho não pode ser vazio.');
    }
    _checkGrapes(grapes);
  }

  /// Id do produtor ("Produtor Desconhecido" quando não se sabe).
  final EntityId producerId;
  final String _name;

  /// Safra: ano, NV ou desconhecida. Sempre informada explicitamente.
  final Vintage vintage;

  /// Tipo do vinho; nulo quando não informado.
  final WineType? type;
  final EntityId? countryId;
  final EntityId? regionId;

  /// Composição de uvas. Lista imutável.
  final List<GrapeComposition> grapes;
  final AlcoholContent? alcoholContent;

  /// Nome comercial, como o usuário digitou (sem espaços nas pontas).
  String get name => _name;

  /// Chave de identidade: produtor + nome normalizado + safra.
  WineIdentity get identity => WineIdentity(producerId, _name, vintage);

  /// Mesmo vinho (mesma safra), ainda que em outro registro.
  bool isSameWineAs(Wine other) => identity == other.identity;

  /// Mesmo rótulo, em qualquer safra.
  bool isSameLabelAs(Wine other) => identity.isSameLabelAs(other.identity);

  static void _checkGrapes(List<GrapeComposition> grapes) {
    final seen = <EntityId>{};
    var total = 0.0;
    for (final grape in grapes) {
      if (!seen.add(grape.grapeId)) {
        throw const DomainException(
          'A mesma uva não pode aparecer duas vezes na composição.',
        );
      }
      total += grape.percentage ?? 0;
    }
    if (total > 100.0001) {
      throw DomainException(
        'A soma dos percentuais das uvas não pode passar de 100%. '
        'Soma informada: ${total.toStringAsFixed(1)}%.',
      );
    }
  }

  @override
  String toString() => '$_name ($vintage)';
}
