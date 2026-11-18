import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';

/// De onde veio um dado (ADR-027).
enum DataOrigin {
  /// Informado pelo próprio usuário.
  user,

  /// Sugerido por inteligência artificial.
  aiSuggestion,

  /// Obtido de uma fonte externa (site, loja, publicação).
  externalSource,
}

/// Grau de confiança de um dado sugerido.
enum ConfidenceLevel { low, medium, high }

/// Procedência de um dado: origem, confiança, fonte e confirmação
/// (ADR-027).
///
/// Regras:
/// - dado informado pelo usuário já nasce confirmado;
/// - dado sugerido (IA ou fonte externa) exige um nível de confiança e
///   nasce não confirmado, até que o usuário o confirme.
final class Provenance {
  Provenance._({
    required this.origin,
    required this.recordedAt,
    required this.confirmed,
    this.confidence,
    this.source,
    this.confirmedAt,
  });

  /// Dado informado pelo usuário: confirmado desde a origem.
  factory Provenance.user({required DateTime recordedAt}) {
    return Provenance._(
      origin: DataOrigin.user,
      recordedAt: recordedAt,
      confirmed: true,
      confirmedAt: recordedAt,
    );
  }

  /// Dado sugerido por IA ou fonte externa: começa não confirmado.
  factory Provenance.suggestion({
    required DataOrigin origin,
    required ConfidenceLevel confidence,
    required DateTime recordedAt,
    String? source,
  }) {
    if (origin == DataOrigin.user) {
      throw const DomainException(
        'Um dado informado pelo usuário não é uma sugestão.',
      );
    }
    return Provenance._(
      origin: origin,
      recordedAt: recordedAt,
      confirmed: false,
      confidence: confidence,
      source: cleanOptionalText(source),
    );
  }

  final DataOrigin origin;

  /// Confiança da sugestão; nula para dados do usuário.
  final ConfidenceLevel? confidence;

  /// Fonte (ex.: "Pesquisa assistida por IA", nome de um site).
  final String? source;

  /// Quando o dado foi registrado.
  final DateTime recordedAt;

  /// Se o usuário confirmou o dado.
  final bool confirmed;

  /// Quando o dado foi confirmado; nulo enquanto não confirmado.
  final DateTime? confirmedAt;

  bool get isSuggestion => origin != DataOrigin.user;

  /// Confirma uma sugestão, preservando origem, confiança e fonte.
  Provenance confirm({required DateTime at}) {
    if (confirmed) {
      return this;
    }
    return Provenance._(
      origin: origin,
      recordedAt: recordedAt,
      confirmed: true,
      confidence: confidence,
      source: source,
      confirmedAt: at,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Provenance &&
          other.origin == origin &&
          other.confidence == confidence &&
          other.source == source &&
          other.recordedAt == recordedAt &&
          other.confirmed == confirmed &&
          other.confirmedAt == confirmedAt;

  @override
  int get hashCode => Object.hash(
    origin,
    confidence,
    source,
    recordedAt,
    confirmed,
    confirmedAt,
  );
}

/// Um valor acompanhado da sua procedência (ADR-027).
///
/// Ex.: `Sourced<AlcoholContent>` com teor sugerido pela IA, ainda não
/// confirmado.
final class Sourced<T extends Object> {
  const Sourced(this.value, this.provenance);

  final T value;
  final Provenance provenance;

  bool get isConfirmed => provenance.confirmed;

  /// Confirma o valor, mantendo o mesmo conteúdo.
  Sourced<T> confirm({required DateTime at}) {
    return Sourced(value, provenance.confirm(at: at));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sourced<T> &&
          other.value == value &&
          other.provenance == provenance;

  @override
  int get hashCode => Object.hash(value, provenance);
}
