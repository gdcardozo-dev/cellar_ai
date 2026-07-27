class Money {
  final double value;
  final String currency;

  const Money({
    required this.value,
    this.currency = 'BRL',
  });

  @override
  String toString() => '$currency ${value.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          value == other.value &&
          currency == other.currency;

  @override
  int get hashCode => Object.hash(value, currency);
}