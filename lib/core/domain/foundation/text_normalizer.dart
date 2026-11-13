/// Normaliza texto para comparação (ADR-014): minúsculas, sem acentos e
/// sem espaços extras.
///
/// Ex.: "  Château   Margaux " → "chateau margaux".
String normalizeForComparison(String text) {
  final lower = text.toLowerCase();
  final buffer = StringBuffer();
  for (final char in lower.split('')) {
    buffer.write(_accents[char] ?? char);
  }
  final withoutMarks = buffer.toString().replaceAll(_combiningMarks, '');
  return withoutMarks.trim().replaceAll(_spaces, ' ');
}

final _combiningMarks = RegExp(r'[\u0300-\u036f]');
final _spaces = RegExp(r'\s+');

const _accents = {
  'á': 'a',
  'à': 'a',
  'â': 'a',
  'ã': 'a',
  'ä': 'a',
  'å': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'í': 'i',
  'ì': 'i',
  'î': 'i',
  'ï': 'i',
  'ó': 'o',
  'ò': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ø': 'o',
  'ú': 'u',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ç': 'c',
  'ñ': 'n',
  'ý': 'y',
  'ÿ': 'y',
  'æ': 'ae',
  'œ': 'oe',
  'ß': 'ss',
};
