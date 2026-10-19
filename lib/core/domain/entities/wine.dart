class Wine {
  const Wine({
    required this.id,
    required this.producer,
    required this.label,
    this.vintage,
    this.country,
    this.region,
    this.grapes = const [],
    this.purchasePrice,
    this.purchaseDate,
    this.quantity = 1,
    this.notes,
  });

  /// Identificador único
  final String id;

  /// Produtor
  final String producer;

  /// Nome comercial do vinho
  final String label;

  /// Safra
  final int? vintage;

  /// País de origem
  final String? country;

  /// Região
  final String? region;

  /// Uvas
  final List<String> grapes;

  /// Valor pago
  final double? purchasePrice;

  /// Data da compra
  final DateTime? purchaseDate;

  /// Quantidade de garrafas
  final int quantity;

  /// Observações pessoais
  final String? notes;
}
