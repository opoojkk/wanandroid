class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);

  @override
  bool operator ==(other) {
    if (!(other is Pair)) {
      return false;
    }
    Pair p = other;
    return first == p.first && second == p.second;
  }

  @override
  int get hashCode => (first?.hashCode ?? 0) ^ (second?.hashCode ?? 0);

  static Pair<A, B> create<A, B>(A a, B b) {
    return Pair<A, B>(a, b);
  }
}
