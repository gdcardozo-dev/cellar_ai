import '../foundation/domain_exception.dart';
import 'provenance.dart';

/// Categoria de consumo de um vinho em um ano (ADR-032).
enum ConsumptionStatus {
  /// Antes da janela, ou antes da melhor fase.
  canWait,

  /// Dentro da janela, sem urgência.
  bestMoment,

  /// Último ano da janela.
  openNow,

  /// Depois da janela.
  storageAttention,

  /// Sem janela de consumo informada.
  noInformation,
}

/// Janela de consumo: do ano [fromYear] ao ano [untilYear], com melhor
/// fase opcional de [peakFromYear] a [peakToYear] (ADR-032).
final class DrinkingWindow {
  DrinkingWindow({
    required this.fromYear,
    required this.untilYear,
    this.peakFromYear,
    this.peakToYear,
  }) {
    if (fromYear > untilYear) {
      throw const DomainException(
        'O início da janela de consumo não pode ser depois do fim.',
      );
    }
    final peakFrom = peakFromYear;
    final peakTo = peakToYear;
    if ((peakFrom == null) != (peakTo == null)) {
      throw const DomainException(
        'Informe o início e o fim da melhor fase, ou nenhum dos dois.',
      );
    }
    if (peakFrom != null && peakTo != null) {
      if (peakFrom < fromYear || peakTo > untilYear || peakFrom > peakTo) {
        throw const DomainException(
          'A melhor fase deve estar dentro da janela de consumo.',
        );
      }
    }
  }

  final int fromYear;
  final int untilYear;
  final int? peakFromYear;
  final int? peakToYear;

  /// Categoria de consumo no ano [year], pelas regras da ADR-032.
  ConsumptionStatus statusIn(int year) {
    if (year < fromYear) {
      return ConsumptionStatus.canWait;
    }
    if (year > untilYear) {
      return ConsumptionStatus.storageAttention;
    }
    if (year == untilYear) {
      return ConsumptionStatus.openNow;
    }
    final peakFrom = peakFromYear;
    if (peakFrom != null && year < peakFrom) {
      return ConsumptionStatus.canWait;
    }
    return ConsumptionStatus.bestMoment;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrinkingWindow &&
          other.fromYear == fromYear &&
          other.untilYear == untilYear &&
          other.peakFromYear == peakFromYear &&
          other.peakToYear == peakToYear;

  @override
  int get hashCode =>
      Object.hash(fromYear, untilYear, peakFromYear, peakToYear);
}

/// Resultado da avaliação de consumo: a categoria e se ela se baseia em
/// uma janela ainda não confirmada (sugestão).
final class ConsumptionAssessment {
  const ConsumptionAssessment(this.status, {this.isSuggestion = false});

  /// Avalia a janela (com procedência) no ano [currentYear].
  factory ConsumptionAssessment.of(
    Sourced<DrinkingWindow>? window, {
    required int currentYear,
  }) {
    if (window == null) {
      return const ConsumptionAssessment(ConsumptionStatus.noInformation);
    }
    return ConsumptionAssessment(
      window.value.statusIn(currentYear),
      isSuggestion: !window.isConfirmed,
    );
  }

  final ConsumptionStatus status;
  final bool isSuggestion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumptionAssessment &&
          other.status == status &&
          other.isSuggestion == isSuggestion;

  @override
  int get hashCode => Object.hash(status, isSuggestion);
}
