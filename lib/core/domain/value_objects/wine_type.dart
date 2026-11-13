/// Tipo do vinho, em linguagem simples (ADR-021).
///
/// Lista única, que combina cor e estilo: um espumante rosé é [sparkling].
/// Os textos exibidos ao usuário ("Tinto", "Branco"...) pertencem à
/// camada de apresentação.
enum WineType { red, white, rose, orange, sparkling, fortified, dessert }
