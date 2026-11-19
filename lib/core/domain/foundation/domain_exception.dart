/// Exceção lançada quando uma regra de negócio do domínio é violada.
///
/// Implementa [Exception] (situação prevista, que o app trata e mostra
/// ao usuário), e não [Error] (que, no Dart, indica bug de programação).
class DomainException implements Exception {
  const DomainException(this.message);

  /// Mensagem em português, adequada para exibição ao usuário.
  final String message;

  @override
  String toString() => 'DomainException: $message';
}
