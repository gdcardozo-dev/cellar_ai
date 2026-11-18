import 'package:cellar_ai/core/domain/entities/acquisition.dart';
import 'package:cellar_ai/core/domain/entities/cellar_lot.dart';
import 'package:cellar_ai/core/domain/entities/country.dart';
import 'package:cellar_ai/core/domain/entities/market_valuation.dart';
import 'package:cellar_ai/core/domain/entities/producer.dart';
import 'package:cellar_ai/core/domain/entities/wine.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/money.dart';
import 'package:cellar_ai/core/domain/value_objects/provenance.dart';
import 'package:cellar_ai/core/domain/value_objects/vintage.dart';

/// Adega real de 12 garrafas (`docs/PRODUCT_EVOLUTION_PLAN.md`, seção 5).
///
/// Uso exclusivo em testes e em um futuro modo demonstração: nunca deve
/// ser inserida automaticamente na adega real. Campos desconhecidos ficam
/// vazios; nada é inventado.
abstract final class RealCellar12 {
  static final recordedAt = DateTime(2026, 11, 18);

  static final countries = [
    Country(id: const EntityId('pt'), name: 'Portugal'),
    Country(id: const EntityId('ar'), name: 'Argentina'),
    Country(id: const EntityId('it'), name: 'Itália'),
    Country(id: const EntityId('cl'), name: 'Chile'),
  ];

  static final producers = [
    _producer('espaco-rural', 'Espaço Rural'),
    _producer('nieto-senetiner', 'Nieto Senetiner'),
    _producer('tenuta-marcianella', 'Tenuta Marcianella'),
    _producer('vina-cobos', 'Viña Cobos'),
    _producer('carmim', 'CARMIM'),
    _producer('aveleda', 'Aveleda'),
    _producer('luigi-bosca', 'Luigi Bosca'),
    _producer('esporao', 'Esporão'),
    _producer('cartuxa', 'Cartuxa (Fundação Eugénio de Almeida)'),
    _producer('van-zeller', 'Van Zeller Wine Collection'),
    _producer('concha-y-toro', 'Concha y Toro'),
  ];

  static final wines = [
    _wine('001', 'espaco-rural', 'Bojador Amphora Tinto', null, 'pt'),
    _wine(
      '002',
      'nieto-senetiner',
      'Single Vineyard Villa Blanca Malbec',
      2023,
      'ar',
    ),
    _wine(
      '003',
      'tenuta-marcianella',
      'Vino Nobile di Montepulciano',
      2023,
      'it',
    ),
    _wine('004', 'vina-cobos', 'Bramare Luján de Cuyo Malbec', 2023, 'ar'),
    _wine('005', 'carmim', 'Reguengos Tinto', 2024, 'pt'),
    _wine('006', 'aveleda', 'Solos de Xisto Alvarinho', 2024, 'pt'),
    _wine('007', 'luigi-bosca', 'Insignia Malbec', 2022, 'ar'),
    _wine('008', 'esporao', 'Monte Velho Tinto', 2024, 'pt'),
    _wine('009', 'cartuxa', 'EA Tinto', 2023, 'pt'),
    _wine(
      '010',
      'van-zeller',
      "Iron Maiden Eddie's Blend Darkest Red",
      2024,
      'pt',
    ),
    _wine(
      '011',
      'concha-y-toro',
      'Casillero del Diablo Reserva Cabernet Sauvignon',
      2024,
      'cl',
    ),
    _wine(
      '012',
      'concha-y-toro',
      "Casillero del Diablo Devil's Carnaval Spectacular Cabernet",
      null,
      'cl',
    ),
  ];

  /// Compras. Só são conhecidos o lote Grand Cru (001–004) e os valores
  /// pagos em euro (006 e 010); as demais têm valor e data desconhecidos.
  static final acquisitions = [
    Acquisition(
      id: const EntityId('compra-grand-cru'),
      totalPaid: Money(cents: 59993),
      supplier: 'Grand Cru',
    ),
    _unknownPurchase('005'),
    Acquisition(
      id: const EntityId('compra-006'),
      totalPaid: Money(cents: 700, currency: 'EUR'),
    ),
    _unknownPurchase('007'),
    _unknownPurchase('008'),
    _unknownPurchase('009'),
    Acquisition(
      id: const EntityId('compra-010'),
      totalPaid: Money(cents: 1300, currency: 'EUR'),
    ),
    _unknownPurchase('011'),
    _unknownPurchase('012'),
  ];

  /// Um lote de 1 garrafa por vinho, sem preço individual.
  static final lots = [
    for (final id in ['001', '002', '003', '004'])
      _lot(id, acquisitionId: 'compra-grand-cru'),
    for (final id in ['005', '006', '007', '008', '009', '010', '011', '012'])
      _lot(id, acquisitionId: 'compra-$id'),
  ];

  /// Estimativas históricas de reposição (R$): sugestões de baixa
  /// confiança, com data de referência desconhecida. Não são cotações
  /// atuais.
  static final valuations = [
    _estimate('005', 5500),
    _estimate('006', 23000),
    _estimate('007', 18000),
    _estimate('008', 7500),
    _estimate('009', 7500),
    _estimate('010', 19000),
    _estimate('011', 6000),
    _estimate('012', 6000),
  ];

  static EntityId wineId(String id) => EntityId('vinho-$id');

  static EntityId lotId(String id) => EntityId('lote-$id');

  static CellarLot lotOf(String id) =>
      lots.firstWhere((lot) => lot.id == lotId(id));

  static Wine wineOf(String id) =>
      wines.firstWhere((wine) => wine.id == wineId(id));

  static Producer _producer(String id, String name) =>
      Producer(id: EntityId(id), name: name);

  /// [year] nulo = safra desconhecida (001 e 012). Nunca inferida.
  static Wine _wine(
    String id,
    String producerId,
    String name,
    int? year,
    String countryId,
  ) {
    return Wine(
      id: wineId(id),
      producerId: EntityId(producerId),
      name: name,
      vintage: year == null ? const UnknownVintage() : VintageYear(year),
      countryId: EntityId(countryId),
    );
  }

  static Acquisition _unknownPurchase(String id) =>
      Acquisition(id: EntityId('compra-$id'));

  static CellarLot _lot(String id, {required String acquisitionId}) {
    return CellarLot(
      id: lotId(id),
      wineId: wineId(id),
      acquisitionId: EntityId(acquisitionId),
      acquiredQuantity: 1,
    );
  }

  static MarketValuation _estimate(String id, int cents) {
    return MarketValuation(
      id: EntityId('estimativa-$id'),
      wineId: wineId(id),
      value: Money(cents: cents),
      kind: ValuationKind.replacement,
      provenance: Provenance.suggestion(
        origin: DataOrigin.aiSuggestion,
        confidence: ConfidenceLevel.low,
        recordedAt: recordedAt,
        source: 'Estimativa histórica (catalogação assistida)',
      ),
    );
  }
}
