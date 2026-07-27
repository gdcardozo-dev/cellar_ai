class Vintage {
  final int year;

  const Vintage(this.year)
      : assert(year >= 1800 && year <= 2100);

  @override
  String toString() => year.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vintage && other.year == year;

  @override
  int get hashCode => year.hashCode;
}