import 'package:cellar_ai/core/domain/entities/acquisition.dart';
import 'package:cellar_ai/core/domain/entities/cellar_lot.dart';
import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/acquisition_origin.dart';
import 'package:cellar_ai/core/domain/value_objects/cellar_removal.dart';
import 'package:cellar_ai/core/domain/value_objects/entity_id.dart';
import 'package:cellar_ai/core/domain/value_objects/money.dart';
import 'package:cellar_ai/core/domain/value_objects/package_size.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 11, 18);
  const grandCru = EntityId('compra-grand-cru');
  const insignia = EntityId('insignia');

  CellarLot lot({int quantity = 3, int? available}) {
    return CellarLot(
      id: const EntityId('lote-1'),
      wineId: insignia,
      acquisitionId: grandCru,
      acquiredQuantity: quantity,
      available: available,
    );
  }

  CellarRemoval removal({int quantity = 1}) {
    return CellarRemoval(
      reason: RemovalReason.broken,
      quantity: quantity,
      date: today,
    );
  }

  group('Acquisition', () {
    test('compra conjunta com valor total e sem preços individuais', () {
      final purchase = Acquisition(
        id: grandCru,
        totalPaid: Money(cents: 59993),
        date: DateTime(2026, 10, 1),
        supplier: ' Grand Cru ',
        now: today,
      );

      expect(purchase.origin, AcquisitionOrigin.purchase);
      expect(purchase.totalPaid, Money(cents: 59993));
      expect(purchase.supplier, 'Grand Cru');
    });

    test('deve aceitar compra com data e valor desconhecidos', () {
      final purchase = Acquisition(id: grandCru, now: today);

      expect(purchase.date, isNull);
      expect(purchase.totalPaid, isNull);
    });

    test('deve aceitar compra em outra moeda', () {
      final purchase = Acquisition(
        id: grandCru,
        totalPaid: Money(cents: 700, currency: 'EUR'),
        now: today,
      );

      expect(purchase.totalPaid!.currency, 'EUR');
    });

    test('presente recebido não deve ter valor pago', () {
      expect(
        () => Acquisition(
          id: grandCru,
          origin: AcquisitionOrigin.gift,
          totalPaid: Money(cents: 100),
          now: today,
        ),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve recusar data futura', () {
      expect(
        () => Acquisition(
          id: grandCru,
          date: DateTime(2026, 11, 19),
          now: today,
        ),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('CellarLot — criação', () {
    test('lote novo começa com tudo disponível e garrafa padrão', () {
      final l = lot();

      expect(l.available, 3);
      expect(l.packageSize, PackageSize.standard);
      expect(l.unitPrice, isNull);
    });

    test('deve recusar lote sem garrafas', () {
      expect(() => lot(quantity: 0), throwsA(isA<DomainException>()));
    });

    test('deve recusar disponível maior que o adquirido ou negativo', () {
      expect(() => lot(available: 4), throwsA(isA<DomainException>()));
      expect(() => lot(available: -1), throwsA(isA<DomainException>()));
    });
  });

  group('CellarLot — retiradas', () {
    test('retirar para uma história reduz 1 garrafa', () {
      expect(lot().takeBottleForStory().available, 2);
    });

    test('não deve alterar o lote original', () {
      final l = lot();

      l.takeBottleForStory();

      expect(l.available, 3);
    });

    test('deve recusar retirada de lote vazio', () {
      final empty = lot(quantity: 1).takeBottleForStory();

      expect(empty.isEmpty, isTrue);
      expect(empty.takeBottleForStory, throwsA(isA<DomainException>()));
    });

    test('baixa avulsa reduz a quantidade e fica registrada', () {
      final l = lot().registerRemoval(removal(quantity: 2));

      expect(l.available, 1);
      expect(l.removals, hasLength(1));
      expect(l.removals.first.reason, RemovalReason.broken);
    });

    test('deve recusar baixa maior que o disponível', () {
      expect(
        () => lot(quantity: 1).registerRemoval(removal(quantity: 2)),
        throwsA(isA<DomainException>()),
      );
    });

    test('baixa deve ser de pelo menos 1 garrafa', () {
      expect(() => removal(quantity: 0), throwsA(isA<DomainException>()));
    });

    test('a lista de baixas não deve poder ser alterada de fora', () {
      final l = lot().registerRemoval(removal());

      expect(() => l.removals.add(removal()), throwsUnsupportedError);
    });
  });
}
