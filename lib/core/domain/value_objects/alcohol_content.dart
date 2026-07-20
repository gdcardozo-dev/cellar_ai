class AlcoholContent {
  final double percentage;

  const AlcoholContent(this.percentage)
      : assert(percentage >= 0 && percentage <= 100);

  @override
  String toString() => '${percentage.toStringAsFixed(1)}%';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlcoholContent &&
          other.percentage == percentage;

  @override
  int get hashCode => percentage.hashCode;
}