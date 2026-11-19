import 'package:cellar_ai/core/application/cellar/register_cellar_removal.dart';
import 'package:cellar_ai/core/application/cellar/register_purchase.dart';
import 'package:cellar_ai/core/application/stories/register_person.dart';
import 'package:cellar_ai/core/domain/entities/acquisition.dart';
import 'package:cellar_ai/core/domain/entities/cellar_lot.dart';
import 'package:cellar_ai/core/domain/entities/person.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/acquisition_origin.dart';
import 'package:cellar_ai/core/domain/value_objects/cellar_removal.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/money.dart';
import 'package:cellar_ai/infrastructure/in_memory/in_memory_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/real_cellar_12.dart';

void main() {
  final today = DateTime(2026, 11, 19);
  const purchaseId = EntityId('nova-compra');

  late InMemoryAcquisitionRepository acquisitions;
  late InMemoryCellarLotRepository lots;
  late InMemoryWineRepository wines;
  late InMemoryPersonRepository people;
  late RegisterPurchase registerPurchase;
  late RegisterCellarRemoval registerRemoval;
  late RegisterPerson registerPerson;

  setUp(() {
    acquisitions = InMemoryAcquisitionRepository();
    lots = InMemoryCellarLotRepository(RealCellar12.lots);
    wines = InMemoryWineRepository(RealCellar12.wines);
    people = InMemoryPersonRepository();
    registerPurchase = RegisterPurchase(
      acquisitions: acquisitions,
      lots: lots,
      wines: wines,
    );
    registerRemoval = RegisterCellarRemoval(lots: lots);
    registerPerson = RegisterPerson(people: people);
  });

  Acquisition purchase({
    Money? total,
    AcquisitionOrigin origin = AcquisitionOrigin.purchase,
  }) {
    return Acquisition(
      id: purchaseId,
      origin: origin,
      totalPaid: total,
      now: today,
    );
  }

  CellarLot newLot(
    String id, {
    String wine = '007',
    EntityId acquisitionId = purchaseId,
    Money? unitPrice,
    int quantity = 2,
  }) {
    return CellarLot(
      id: EntityId(id),
      wineId: RealCellar12.wineId(wine),
      acquisitionId: acquisitionId,
      acquiredQuantity: quantity,
      unitPrice: unitPrice,
    );
  }

  group('Registrar compra', () {
    test('compra conjunta: 1 compra e vários lotes sem preço', () async {
      await registerPurchase(purchase(total: Money(cents: 59993)), [
        newLot('n1', wine: '001'),
        newLot('n2', wine: '002'),
      ]);

      expect(await acquisitions.findById(purchaseId), isNotNull);
      expect(await lots.findById(const EntityId('n1')), isNotNull);
      expect(await lots.findById(const EntityId('n2')), isNotNull);
    });

    test('preço do lote em moeda diferente da compra é recusado', () async {
      final total = Money(cents: 700, currency: 'EUR');
      final lot = newLot('n1', unitPrice: Money(cents: 4000));

      await expectLater(
        registerPurchase(purchase(total: total), [lot]),
        throwsA(isA<DomainException>()),
      );
      expect(await acquisitions.findById(purchaseId), isNull);
    });

    test('preço do lote na mesma moeda da compra é aceito', () async {
      final total = Money(cents: 700, currency: 'EUR');
      final price = Money(cents: 700, currency: 'EUR');

      await registerPurchase(purchase(total: total), [
        newLot('n1', unitPrice: price, quantity: 1),
      ]);

      expect(await lots.findById(const EntityId('n1')), isNotNull);
    });

    test('presente recebido com preço no lote é recusado', () async {
      final gift = purchase(origin: AcquisitionOrigin.gift);
      final lot = newLot('n1', unitPrice: Money(cents: 100));

      await expectLater(
        registerPurchase(gift, [lot]),
        throwsA(isA<DomainException>()),
      );
    });

    test('compra sem lotes é recusada', () async {
      await expectLater(
        registerPurchase(purchase(), []),
        throwsA(isA<DomainException>()),
      );
    });

    test('lote de outra compra é recusado e nada é salvo', () async {
      final ok = newLot('n1');
      final wrong = newLot('n2', acquisitionId: const EntityId('outra'));

      await expectLater(
        registerPurchase(purchase(), [ok, wrong]),
        throwsA(isA<DomainException>()),
      );
      expect(await acquisitions.findById(purchaseId), isNull);
      expect(await lots.findById(const EntityId('n1')), isNull);
    });

    test('vinho fora do catálogo é recusado', () async {
      await expectLater(
        registerPurchase(purchase(), [newLot('n1', wine: '999')]),
        throwsA(isA<DomainException>()),
      );
    });

    test('lote já existente é recusado', () async {
      await expectLater(
        registerPurchase(purchase(), [newLot('lote-007')]),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('Baixa avulsa', () {
    CellarRemoval broken({int quantity = 1}) {
      return CellarRemoval(
        reason: RemovalReason.broken,
        quantity: quantity,
        date: today,
      );
    }

    test('garrafa quebrada sai da adega e fica registrada', () async {
      await registerRemoval(RealCellar12.lotId('008'), broken());

      final lot = await lots.findById(RealCellar12.lotId('008'));
      expect(lot!.available, 0);
      expect(lot.removals.single.reason, RemovalReason.broken);
    });

    test('baixa maior que o disponível é recusada', () async {
      await expectLater(
        registerRemoval(RealCellar12.lotId('008'), broken(quantity: 2)),
        throwsA(isA<DomainException>()),
      );
      expect((await lots.findById(RealCellar12.lotId('008')))!.available, 1);
    });

    test('lote inexistente é recusado', () async {
      await expectLater(
        registerRemoval(const EntityId('xx'), broken()),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('Cadastrar pessoa', () {
    test('pessoa nova é salva', () async {
      await registerPerson(Person(id: const EntityId('p1'), name: 'Ana'));

      expect(await people.findById(const EntityId('p1')), isNotNull);
    });

    test('mesma grafia é recusada e aponta a pessoa existente', () async {
      await registerPerson(Person(id: const EntityId('p1'), name: 'Ana'));

      await expectLater(
        registerPerson(Person(id: const EntityId('p2'), name: '  ÁNA ')),
        throwsA(
          isA<DuplicatePersonException>().having(
            (e) => e.existingPersonId,
            'existingPersonId',
            const EntityId('p1'),
          ),
        ),
      );
    });

    test('homônimo com grafia diferente é aceito', () async {
      await registerPerson(Person(id: const EntityId('p1'), name: 'Ana'));
      await registerPerson(
        Person(id: const EntityId('p2'), name: 'Ana de Brasília'),
      );

      expect(await people.findById(const EntityId('p2')), isNotNull);
    });
  });
}
