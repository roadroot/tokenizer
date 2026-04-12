/// Base abstraction for all token descriptors.
abstract class TokenBase {
  /// Whether this model matches no content.
  bool get isEmpty;

  /// Human-readable token name.
  final String name;

  /// Creates a base token descriptor with a [name].
  const TokenBase({required this.name});

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    return other is TokenBase && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
