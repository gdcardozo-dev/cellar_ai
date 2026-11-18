import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/drinking_window.dart';
import 'package:cellar_ai/core/domain/value_objects/provenance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Exemplo aprovado na ADR-032: janela 2026–2032, melhor fase 2028–2030.
  final window = DrinkingWindow(
    fromYear: 2026,
    untilYear: 2032,
    peakFromYear: 2028,
    peakToYear: 2030,
  );

  group('DrinkingWindow — validação', () {
    test('deve recusar início depois do fim', () {
      expect(
        () => DrinkingWindow(fromYear: 2030, untilYear: 2026),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve exigir início e fim da melhor fase juntos', () {
      expect(
        () => DrinkingWindow(
          fromYear: 2026,
          untilYear: 2032,
          peakFromYear: 2028,
        ),
        throwsA(isA<DomainException>()),
      );
    });

    test('deve recusar melhor fase fora da janela', () {
      expect(
        () => DrinkingWindow(
          fromYear: 2026,
          untilYear: 2032,
          peakFromYear: 2025,
          peakToYear: 2030,
        ),
        throwsA(isA<DomainException>()),
      );
    });
  });

  group('DrinkingWindow — regras da ADR-032', () {
    test('antes da janela: pode esperar', () {
      expect(window.statusIn(2025), ConsumptionStatus.canWait);
    });

    test('na janela, antes da melhor fase: pode esperar', () {
      expect(window.statusIn(2026), ConsumptionStatus.canWait);
      expect(window.statusIn(2027), ConsumptionStatus.canWait);
    });

    test('na melhor fase: no melhor momento', () {
      expect(window.statusIn(2028), ConsumptionStatus.bestMoment);
      expect(window.statusIn(2030), ConsumptionStatus.bestMoment);
    });

    test('depois da melhor fase, ainda na janela: no melhor momento', () {
      expect(window.statusIn(2031), ConsumptionStatus.bestMoment);
    });

    test('último ano da janela: abrir agora', () {
      expect(window.statusIn(2032), ConsumptionStatus.openNow);
    });

    test('depois da janela: atenção à guarda', () {
      expect(window.statusIn(2033), ConsumptionStatus.storageAttention);
    });

    test('sem melhor fase: toda a janela é melhor momento, menos o fim', () {
      final simple = DrinkingWindow(fromYear: 2026, untilYear: 2030);

      expect(simple.statusIn(2026), ConsumptionStatus.bestMoment);
      expect(simple.statusIn(2029), ConsumptionStatus.bestMoment);
      expect(simple.statusIn(2030), ConsumptionStatus.openNow);
    });
  });

  group('ConsumptionAssessment', () {
    final recorded = DateTime(2026, 11, 18);

    test('sem janela: sem informação', () {
      expect(
        ConsumptionAssessment.of(null, currentYear: 2026).status,
        ConsumptionStatus.noInformation,
      );
    });

    test('janela informada pelo usuário não é sugestão', () {
      final sourced = Sourced(window, Provenance.user(recordedAt: recorded));

      final result = ConsumptionAssessment.of(sourced, currentYear: 2029);

      expect(result.status, ConsumptionStatus.bestMoment);
      expect(result.isSuggestion, isFalse);
    });

    test('janela sugerida e não confirmada aparece como sugestão', () {
      final suggestion = Provenance.suggestion(
        origin: DataOrigin.aiSuggestion,
        confidence: ConfidenceLevel.low,
        recordedAt: recorded,
      );
      final sourced = Sourced(window, suggestion);

      final result = ConsumptionAssessment.of(sourced, currentYear: 2029);

      expect(result.status, ConsumptionStatus.bestMoment);
      expect(result.isSuggestion, isTrue);
    });
  });
}
