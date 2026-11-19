/// Limpa um texto opcional: remove espaços nas pontas e transforma texto
/// vazio em `null` ("não informado").
String? cleanOptionalText(String? text) {
  final trimmed = text?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
