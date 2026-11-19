import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/alcohol_content.dart';
import 'package:cellar_ai/core/domain/value_objects/provenance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final recorded = DateTime(2026, 11, 18, 10);
  final later = DateTime(2026, 11, 20, 9);

  Provenance aiSuggestion() => Provenance.suggestion(
    origin: DataOrigin.aiSuggestion,
    confidence: ConfidenceLevel.medium,
    recordedAt: recorded,
    source: ' Pesquisa assistida por IA ',
  );

  group('Provenance', () {
    test('dado do usuário já nasce confirmado', () {
      final p = Provenance.user(recordedAt: recorded);

      expect(p.origin, DataOrigin.user);
      expect(p.confirmed, isTrue);
      expect(p.isSuggestion, isFalse);
      expect(p.confidence, isNull);
    });

    test('sugestão da IA nasce não confirmada, com confiança e fonte', () {
      final p = aiSuggestion();

      expect(p.confirmed, isFalse);
      expect(p.isSuggestion, isTrue);
      expect(p.confidence, ConfidenceLevel.medium);
      expect(p.source, 'Pesquisa assistida por IA');
      expect(p.confirmedAt, isNull);
    });

    test('dado do usuário não pode ser registrado como sugestão', () {
      expect(
        () => Provenance.suggestion(
          origin: DataOrigin.user,
          confidence: ConfidenceLevel.high,
          recordedAt: recorded,
        ),
        throwsA(isA<DomainException>()),
      );
    });

    test('confirmar preserva origem, confiança e fonte', () {
      final confirmed = aiSuggestion().confirm(at: later);

      expect(confirmed.confirmed, isTrue);
      expect(confirmed.confirmedAt, later);
      expect(confirmed.origin, DataOrigin.aiSuggestion);
      expect(confirmed.confidence, ConfidenceLevel.medium);
      expect(confirmed.source, 'Pesquisa assistida por IA');
    });

    test('confirmar não altera a sugestão original', () {
      final original = aiSuggestion();

      original.confirm(at: later);

      expect(original.confirmed, isFalse);
    });

    test('confirmar um dado já confirmado não muda nada', () {
      final p = Provenance.user(recordedAt: recorded);

      expect(p.confirm(at: later), same(p));
    });
  });

  group('Sourced', () {
    test('valor sugerido começa não confirmado', () {
      final alcohol = Sourced(AlcoholContent(14), aiSuggestion());

      expect(alcohol.value, AlcoholContent(14));
      expect(alcohol.isConfirmed, isFalse);
    });

    test('confirmar mantém o valor e marca como confirmado', () {
      final alcohol = Sourced(AlcoholContent(14), aiSuggestion());

      final confirmed = alcohol.confirm(at: later);

      expect(confirmed.value, AlcoholContent(14));
      expect(confirmed.isConfirmed, isTrue);
      expect(alcohol.isConfirmed, isFalse);
    });

    test('valores iguais com a mesma procedência são iguais', () {
      expect(
        Sourced(AlcoholContent(14), aiSuggestion()),
        equals(Sourced(AlcoholContent(14), aiSuggestion())),
      );
    });
  });
}
