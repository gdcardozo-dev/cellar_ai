import '../foundation/aggregate_root.dart';
import '../foundation/domain_exception.dart';
import '../value_objects/alcohol_content.dart';
import '../value_objects/drinking_window.dart';
import '../value_objects/entity_id.dart';
import '../value_objects/grape_blend.dart';
import '../value_objects/provenance.dart';
import '../value_objects/vintage.dart';
import '../value_objects/wine_enrichment.dart';
import '../value_objects/wine_identity.dart';
import '../value_objects/wine_type.dart';

/// Vinho do catálogo pessoal do usuário (ADR-014, ADR-015, ADR-019).
///
/// Identidade de domínio: Produtor + Nome comercial + Safra — sempre
/// confirmados (ADR-027). Região, uvas, teor alcoólico e janela de consumo
/// podem chegar como sugestão e ser confirmados depois (ADR-033).
///
/// Não contém dados de posse (preço, quantidade, compra): isso pertence ao
/// lote da adega (CellarLot). Impedir cadastros duplicados é
/// responsabilidade do caso de uso de cadastro.
///
/// Imutável: confirmar ou descartar uma sugestão devolve um novo Wine.
class Wine extends AggregateRoot {
  Wine({
    required super.id,
    required this.producerId,
    required String name,
    required this.vintage,
    this.type,
    this.countryId,
    this.region,
    this.grapes,
    this.alcoholContent,
    this.drinkingWindow,
  }) : _name = name.trim() {
    if (_name.isEmpty) {
      throw const DomainException('O nome do vinho não pode ser vazio.');
    }
  }

  /// Id do produtor ("Produtor Desconhecido" quando não se sabe).
  final EntityId producerId;
  final String _name;

  /// Safra: ano, NV ou desconhecida. Sempre informada explicitamente.
  final Vintage vintage;

  /// Tipo do vinho; nulo quando não informado.
  final WineType? type;
  final EntityId? countryId;

  /// Região (id), com procedência; nula quando não informada.
  final Sourced<EntityId>? region;

  /// Composição de uvas, com procedência; nula quando não informada.
  final Sourced<GrapeBlend>? grapes;

  /// Teor alcoólico, com procedência; nulo quando não informado.
  final Sourced<AlcoholContent>? alcoholContent;

  /// Janela de consumo, com procedência; nula quando não informada.
  final Sourced<DrinkingWindow>? drinkingWindow;

  /// Nome comercial, como o usuário digitou (sem espaços nas pontas).
  String get name => _name;

  /// Chave de identidade: produtor + nome normalizado + safra.
  WineIdentity get identity => WineIdentity(producerId, _name, vintage);

  /// Mesmo vinho (mesma safra), ainda que em outro registro.
  bool isSameWineAs(Wine other) => identity == other.identity;

  /// Mesmo rótulo, em qualquer safra.
  bool isSameLabelAs(Wine other) => identity.isSameLabelAs(other.identity);

  /// Dados ainda não confirmados pelo usuário.
  List<WineEnrichment> get pendingSuggestions => [
    if (region?.isConfirmed == false) WineEnrichment.region,
    if (grapes?.isConfirmed == false) WineEnrichment.grapes,
    if (alcoholContent?.isConfirmed == false) WineEnrichment.alcoholContent,
    if (drinkingWindow?.isConfirmed == false) WineEnrichment.drinkingWindow,
  ];

  /// Categoria de consumo no ano informado (ADR-032).
  ConsumptionAssessment consumptionIn(int year) =>
      ConsumptionAssessment.of(drinkingWindow, currentYear: year);

  /// Confirma uma sugestão, preservando a sua origem (ADR-027).
  Wine confirm(WineEnrichment field, {required DateTime at}) {
    return _rebuild(
      region: field == WineEnrichment.region ? _confirm(region, at) : region,
      grapes: field == WineEnrichment.grapes ? _confirm(grapes, at) : grapes,
      alcoholContent: field == WineEnrichment.alcoholContent
          ? _confirm(alcoholContent, at)
          : alcoholContent,
      drinkingWindow: field == WineEnrichment.drinkingWindow
          ? _confirm(drinkingWindow, at)
          : drinkingWindow,
    );
  }

  /// Descarta uma sugestão. Dados confirmados não podem ser descartados.
  Wine discard(WineEnrichment field) {
    return _rebuild(
      region: field == WineEnrichment.region ? _discard(region) : region,
      grapes: field == WineEnrichment.grapes ? _discard(grapes) : grapes,
      alcoholContent: field == WineEnrichment.alcoholContent
          ? _discard(alcoholContent)
          : alcoholContent,
      drinkingWindow: field == WineEnrichment.drinkingWindow
          ? _discard(drinkingWindow)
          : drinkingWindow,
    );
  }

  static Sourced<T> _confirm<T extends Object>(Sourced<T>? data, DateTime at) {
    if (data == null) {
      throw const DomainException('Não há dado para confirmar.');
    }
    return data.confirm(at: at);
  }

  static Sourced<T>? _discard<T extends Object>(Sourced<T>? data) {
    if (data == null) {
      throw const DomainException('Não há dado para descartar.');
    }
    if (data.isConfirmed) {
      throw const DomainException(
        'Somente sugestões não confirmadas podem ser descartadas.',
      );
    }
    return null;
  }

  Wine _rebuild({
    required Sourced<EntityId>? region,
    required Sourced<GrapeBlend>? grapes,
    required Sourced<AlcoholContent>? alcoholContent,
    required Sourced<DrinkingWindow>? drinkingWindow,
  }) {
    return Wine(
      id: id,
      producerId: producerId,
      name: _name,
      vintage: vintage,
      type: type,
      countryId: countryId,
      region: region,
      grapes: grapes,
      alcoholContent: alcoholContent,
      drinkingWindow: drinkingWindow,
    );
  }

  @override
  String toString() => '$_name ($vintage)';
}
