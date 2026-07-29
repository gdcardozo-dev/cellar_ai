class Story {
  const Story({
    required this.id,
    required this.title,
    required this.date,
    this.location,
    this.notes,
    this.rating,
    this.photoUrls = const [],
    this.people = const [],
    this.foods = const [],
    this.wineIds = const [],
  });

  /// Identificador único
  final String id;

  /// Ex.: "Jantar de aniversário"
  final String title;

  /// Data da experiência
  final DateTime date;

  /// Restaurante, cidade, vinícola, casa...
  final String? location;

  /// Texto livre escrito pelo usuário
  final String? notes;

  /// Avaliação da experiência (1 a 5)
  final int? rating;

  /// Fotos relacionadas
  final List<String> photoUrls;

  /// Pessoas presentes
  final List<String> people;

  /// Pratos consumidos
  final List<String> foods;

  /// IDs dos vinhos utilizados
  final List<String> wineIds;
}
