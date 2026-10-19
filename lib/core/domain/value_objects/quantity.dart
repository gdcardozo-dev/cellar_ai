class Quantity {
  final int value;

  const Quantity(this.value) : assert(value >= 0);

  Quantity increase(int amount) => Quantity(value + amount);

  Quantity decrease(int amount) => Quantity(value - amount);

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Quantity && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
